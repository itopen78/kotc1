package com.kotc.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.kotc.handler.Http401UnauthorizedEntryPoint;
import com.kotc.handler.LoginDeniedHandler;
import com.kotc.handler.LoginFailureHandler;
import com.kotc.handler.LoginSuccessHandler;
import com.kotc.service.UserService;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	@Value("${kotc.api.url}")
	private String apiUrl;

	@Autowired
    private UserService authenticationProvider;
	
	@Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
	@Override
	protected void configure(AuthenticationManagerBuilder auth) {
		auth.authenticationProvider(authenticationProvider);
	}
	
	@Override
	public void configure(WebSecurity web) throws Exception {
		// static 디렉터리의 하위 파일 목록은 인증 무시 ( = 항상통과 )
        web.ignoring().antMatchers("/assets/**", "/exception", "/error", apiUrl);
	}
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
		.authorizeRequests()
		.antMatchers(apiUrl).permitAll()
		.antMatchers("/log*.do", "/user/join*", "/user/find").permitAll()
		.antMatchers("/*.do").hasAnyRole("ADMIN", "USER")
		.anyRequest().authenticated()
	.and() 
		.formLogin()
		.loginPage("/user/login")
		.loginProcessingUrl("/user/process")
		.usernameParameter("user_id")
		.passwordParameter("passwd")
        .successHandler(successHandler())
        .failureHandler(failureHandler())
		.permitAll()
	.and() 
		.logout()
		.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
		.invalidateHttpSession(true)
		.logoutSuccessUrl("/")
	.and()
		.exceptionHandling()
		.accessDeniedHandler(accessDeniedHandler())
	.and().csrf()
        .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());

	http.headers().frameOptions().sameOrigin();
	}
	
	@Bean
    public LoginSuccessHandler successHandler() throws Exception {
        return new LoginSuccessHandler();
    }	

    @Bean
    public LoginFailureHandler failureHandler() throws Exception {
        return new LoginFailureHandler();
    }

    @Bean
    public LoginDeniedHandler accessDeniedHandler() throws Exception {
        return new LoginDeniedHandler();
    }
    
    @Bean
    public Http401UnauthorizedEntryPoint unauthorizedEntryPoint() throws Exception {
        return new Http401UnauthorizedEntryPoint();
    }
}
