# UniBlend Security Documentation

## Overview
This document outlines the security measures implemented in the UniBlend Laravel application to protect against common cyber threats.

## Implemented Security Features

### 1. Authentication & Authorization
- **Laravel Sanctum**: Token-based API authentication with configurable expiration (default: 24 hours)
- **Role-Based Access Control (RBAC)**: Using `spatie/laravel-permission`
  - Roles: admin, moderator, user
  - Granular permissions for different resources
- **Rate Limiting**: 
  - Auth routes: 5 attempts per minute
  - API routes: 100 requests per minute

### 2. Security Headers
- **X-Content-Type-Options**: nosniff
- **X-Frame-Options**: DENY
- **X-XSS-Protection**: 1; mode=block
- **Referrer-Policy**: strict-origin-when-cross-origin
- **Content-Security-Policy**: Configured for safe script/style loading
- **Strict-Transport-Security**: HSTS enabled in production

### 3. HTTPS Enforcement
- **ForceHttps Middleware**: Redirects HTTP to HTTPS in production
- **Secure Cookies**: Session cookies marked as secure and HttpOnly

### 4. Input Validation & Sanitization
- **BaseFormRequest**: Base class with XSS protection and input sanitization
- **Structured Validation**: Form request classes for auth endpoints
- **CSRF Protection**: Enabled for all web routes

### 5. Security Logging
- **LogSecurityEvents Middleware**: Logs suspicious activities and auth attempts
- **Dedicated Security Log**: Separate log channel for security events
- **Activity Monitoring**: Tracks IP addresses, user agents, and response codes

### 6. File Upload Security
- **Configurable Limits**: Max file size and allowed extensions/MIME types
- **Validation Rules**: Strict file type validation

## Configuration Files

### Security Configuration (`config/security.php`)
Contains centralized security settings:
- Session timeouts
- Login attempt limits
- File upload restrictions
- CSP policies

### Environment Security (`.env.security`)
Template with secure environment variables:
- HTTPS enforcement
- Secure session configuration
- Database security settings
- SMTP security configuration

## Security Best Practices Implemented

1. **Database Security**
   - Uses Eloquent ORM to prevent SQL injection
   - Encrypted sensitive data storage capability
   - Secure database connection configuration

2. **Session Management**
   - Secure session configuration
   - Session timeout controls
   - Encrypted session data

3. **API Security**
   - Token expiration
   - Rate limiting
   - CORS configuration
   - Request validation

4. **Dependency Management**
   - Regular dependency audits with `composer audit`
   - Automated security vulnerability checks

## Monitoring & Logging

### Security Log Location
- **Path**: `storage/logs/security.log`
- **Retention**: 30 days
- **Format**: Daily rotation with structured JSON data

### Monitored Events
- Failed authentication attempts
- Suspicious user activities
- Admin panel access attempts
- CSRF token mismatches
- Bot detection

## Deployment Security Checklist

- [ ] Set `APP_DEBUG=false` in production
- [ ] Configure secure database credentials
- [ ] Enable HTTPS with valid SSL certificate
- [ ] Set up proper file permissions (755 for directories, 644 for files)
- [ ] Configure firewall rules
- [ ] Set up log monitoring and alerting
- [ ] Regular security audits and dependency updates
- [ ] Backup strategy implementation

## Security Incident Response

1. **Detection**: Monitor security logs for suspicious activities
2. **Assessment**: Evaluate the scope and impact of security events
3. **Response**: Follow incident response procedures
4. **Recovery**: Restore services and implement additional protections
5. **Lessons Learned**: Update security measures based on incidents

## Regular Maintenance

- **Weekly**: Review security logs for suspicious activities
- **Monthly**: Update dependencies and run security audits
- **Quarterly**: Review and update security policies
- **Annually**: Comprehensive security assessment

## Contact
For security concerns or to report vulnerabilities, contact the development team immediately.
