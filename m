From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [linux-cifs-client] [PATCH] cifs: use standard token parser for
 mount options
Date: Sat, 26 Jun 2010 13:05:38 -0400
Message-ID: <20100626130538.6b828b40@tlielax.poochiereds.net>
References: <1274356716-25765-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274356716-25765-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 May 2010 07:58:36 -0400
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> cifs_mount now uses the standard token parser for mount options and security options.
> Common cases and aliases are also folded together.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/connect.c |  503 +++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 377 insertions(+), 126 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2208f06..ee78b65 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -34,6 +34,7 @@
>  #include <linux/pagevec.h>
>  #include <linux/freezer.h>
>  #include <linux/namei.h>
> +#include <linux/parser.h>
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
>  #include <linux/inet.h>
> @@ -52,11 +53,184 @@
>  #define CIFS_PORT 445
>  #define RFC1001_PORT 139
>  
> +
>  extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
>  			 unsigned char *p24);
>  
>  extern mempool_t *cifs_req_poolp;
>  
> +/* mount options */
> +enum {
> +	Opt_user_xattr, Opt_nouser_xattr,
> +	Opt_user, Opt_pass,
> +	Opt_ip, Opt_addr,
> +	Opt_sec, Opt_unc,
> +	Opt_target, Opt_path,
> +	Opt_domain, Opt_workgroup,
> +	Opt_prefixpath,	Opt_iocharset,
> +	Opt_uid, Opt_forceuid,
> +	Opt_noforceuid, Opt_gid,
> +	Opt_forcegid, Opt_noforcegid,
> +	Opt_file_mode, Opt_dir_mode,
> +	Opt_port, Opt_rsize,
> +	Opt_wsize, Opt_sockopt,
> +	Opt_netbiosname, Opt_servername,
> +	Opt_credentials, Opt_version,
> +	Opt_guest, Opt_rw,
> +	Opt_ro,	Opt_noblocksend,
> +	Opt_noautotune, Opt_suid,
> +	Opt_nosuid, Opt_exec,
> +	Opt_noexec, Opt_nodev,
> +	Opt_noauto, Opt_dev,
> +	Opt_hard, Opt_soft,
> +	Opt_perm, Opt_noperm,
> +	Opt_mapchars, Opt_nomapchars,
> +	Opt_sfu, Opt_nosfu,
> +	Opt_nodfs, Opt_posixpaths,
> +	Opt_noposixpaths, Opt_nounix,
> +	Opt_nolinux, Opt_nocase,
> +	Opt_ignorecase, Opt_brl,
> +	Opt_nobrl, Opt_nolock,
> +	Opt_forcemandatorylock, Opt_setuids,
> +	Opt_nosetuids, Opt_dynperm,
> +	Opt_nodynperm, Opt_nohard,
> +	Opt_nosoft, Opt_nointr,
> +	Opt_intr, Opt_nostrictsync,
> +	Opt_strictsync, Opt_serverino,
> +	Opt_noserverino, Opt_cifsacl,
> +	Opt_nocifsacl, Opt_acl,
> +	Opt_noacl, Opt_locallease,
> +	Opt_sign, Opt_seal,
> +	Opt_direct, Opt_forcedirectio,
> +	Opt_noac
> +};
> +
> +static const match_table_t cifs_mount_options = {
> +	{ Opt_user_xattr, "user_xattr" },
> +	{ Opt_nouser_xattr, "nouser_xattr" },
> +	{ Opt_user, "user" },
> +	{ Opt_pass, "pass" },
> +	{ Opt_ip, "ip" },
> +	{ Opt_addr, "addr" },
> +	{ Opt_sec, "sec" },
> +	{ Opt_unc, "unc" },
> +	{ Opt_target, "target" },
> +	{ Opt_path, "path" },
> +	{ Opt_domain, "dom" },
> +	{ Opt_domain, "domain" },
> +	{ Opt_workgroup, "workg" },
> +	{ Opt_workgroup, "workgroup" },
> +	{ Opt_prefixpath, "prefixpath" },
> +	{ Opt_iocharset, "iocharset" },
> +	{ Opt_uid, "uid" },
> +	{ Opt_forceuid, "forceuid" },
> +	{ Opt_noforceuid, "noforceuid" },
> +	{ Opt_gid, "gid" },
> +	{ Opt_forcegid, "forcegid" },
> +	{ Opt_noforcegid, "noforcegid" },
> +	{ Opt_file_mode, "file_" },
> +	{ Opt_file_mode, "file_mode" },
> +	{ Opt_dir_mode, "dir_" },
> +	{ Opt_dir_mode, "dir_mode" },
> +	{ Opt_dir_mode, "dirm" },
> +	{ Opt_dir_mode, "dirmode" },
> +	{ Opt_port, "port" },
> +	{ Opt_rsize, "rsize" },
> +	{ Opt_wsize, "wsize" },
> +	{ Opt_sockopt, "socko" },
> +	{ Opt_sockopt, "sockopt" },
> +	{ Opt_netbiosname, "netb" },
> +	{ Opt_netbiosname, "netbiosname" },
> +	{ Opt_servername, "servern" },
> +	{ Opt_servername, "servername" },
> +	{ Opt_credentials, "cred" },
> +	{ Opt_credentials, "credentials" },
> +	{ Opt_version, "ver" },
> +	{ Opt_version, "version" },
> +	{ Opt_guest, "guest" },
> +	{ Opt_rw, "rw" },
> +	{ Opt_ro, "ro" },
> +	{ Opt_noblocksend, "noblocksend" },
> +	{ Opt_noautotune, "noautotune" },
> +	{ Opt_suid, "suid" },
> +	{ Opt_nosuid, "nosuid" },
> +	{ Opt_exec, "exec" },
> +	{ Opt_noexec, "noexec" },
> +	{ Opt_nodev, "nodev" },
> +	{ Opt_noauto, "noauto" },
> +	{ Opt_dev, "dev" },
> +	{ Opt_hard, "hard" },
> +	{ Opt_soft, "soft" },
> +	{ Opt_perm, "perm" },
> +	{ Opt_noperm, "noperm" },
> +	{ Opt_mapchars, "mapchars" },
> +	{ Opt_nomapchars, "nomapchars" },
> +	{ Opt_sfu, "sfu" },
> +	{ Opt_nosfu, "nosfu" },
> +	{ Opt_nodfs, "nodfs" },
> +	{ Opt_posixpaths, "posixpaths" },
> +	{ Opt_noposixpaths, "noposixpaths" },
> +	{ Opt_nounix, "nounix" },
> +	{ Opt_nolinux, "nolinux" },
> +	{ Opt_nocase, "nocase" },
> +	{ Opt_ignorecase, "ignorecase" },
> +	{ Opt_brl, "brl" },
> +	{ Opt_nobrl, "nobrl" },
> +	{ Opt_nolock, "nolock" },
> +	{ Opt_forcemandatorylock, "forcemand" },
> +	{ Opt_forcemandatorylock, "forcemandatorylock" },
> +	{ Opt_setuids, "setuids" },
> +	{ Opt_nosetuids, "nosetuids" },
> +	{ Opt_dynperm, "dynperm" },
> +	{ Opt_nodynperm, "nodynperm" },
> +	{ Opt_nohard, "nohard" },
> +	{ Opt_nosoft, "nosoft" },
> +	{ Opt_nointr, "nointr" },
> +	{ Opt_intr, "intr" },
> +	{ Opt_nostrictsync, "nostrictsync" },
> +	{ Opt_strictsync, "strictsync" },
> +	{ Opt_serverino, "serveri" },
> +	{ Opt_serverino, "serverino" },
> +	{ Opt_noserverino, "noserveri" },
> +	{ Opt_noserverino, "noserverino" },
> +	{ Opt_cifsacl, "cifsacl" },
> +	{ Opt_nocifsacl, "nocifsacl" },
> +	{ Opt_acl, "acl" },
> +	{ Opt_noacl, "noacl" },
> +	{ Opt_locallease, "locall" },
> +	{ Opt_locallease, "locallease" },
> +	{ Opt_sign, "sign" },
> +	{ Opt_seal, "seal" },
> +	{ Opt_direct, "direct" },
> +	{ Opt_forcedirectio, "forcedirectio" },
> +	{ Opt_noac, "noac" }
> +};
> +
> +/* mount security options */
> +enum {
> +	Opt_sec_krb5, Opt_sec_krb5i,
> +	Opt_sec_krb5p, Opt_sec_ntlmsspi,
> +	Opt_sec_ntlmssp, Opt_sec_ntlmv2i,
> +	Opt_sec_ntlmv2,	Opt_sec_ntlmi,
> +	Opt_sec_ntlm, Opt_sec_nontlm,
> +	Opt_sec_lanman,	Opt_sec_none
> +};
> +
> +static const match_table_t cifs_sec_options = {
> +	{ Opt_sec_krb5, "krb5" },
> +	{ Opt_sec_krb5i, "krb5i" },
> +	{ Opt_sec_krb5p, "krb5p" },
> +	{ Opt_sec_ntlmsspi, "ntlmsspi" },
> +	{ Opt_sec_ntlmssp, "ntlmssp" },
> +	{ Opt_sec_ntlmv2i, "ntlmv2i" },
> +	{ Opt_sec_ntlmv2, "ntlmv2" },
> +	{ Opt_sec_ntlmi, "ntlmi" },
> +	{ Opt_sec_ntlm, "ntlm" },
> +	{ Opt_sec_nontlm, "nontlm" },
> +	{ Opt_sec_lanman, "lanman" },
> +	{ Opt_sec_none, "none" }
> +};
> +
>  struct smb_vol {
>  	char *username;
>  	char *password;
> @@ -809,6 +983,7 @@ cifs_parse_mount_options(char *options, const char *devname,
>  	short int override_gid = -1;
>  	bool uid_specified = false;
>  	bool gid_specified = false;
> +	substring_t args[MAX_OPT_ARGS];
>  
>  	separator[0] = ',';
>  	separator[1] = 0;
> @@ -859,13 +1034,14 @@ cifs_parse_mount_options(char *options, const char *devname,
>  			continue;
>  		if ((value = strchr(data, '=')) != NULL)
>  			*value++ = '\0';
> -
> -		/* Have to parse this before we parse for "user" */
> -		if (strnicmp(data, "user_xattr", 10) == 0) {
> +		switch (match_token(data, cifs_mount_options, args)) {
> +		case Opt_user_xattr:
>  			vol->no_xattr = 0;
> -		} else if (strnicmp(data, "nouser_xattr", 12) == 0) {
> +			break;
> +		case Opt_nouser_xattr:
>  			vol->no_xattr = 1;
> -		} else if (strnicmp(data, "user", 4) == 0) {
> +			break;
> +		case Opt_user:
>  			if (!value) {
>  				printk(KERN_WARNING
>  				       "CIFS: invalid or missing username\n");
> @@ -880,7 +1056,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				printk(KERN_WARNING "CIFS: username too long\n");
>  				return 1;
>  			}
> -		} else if (strnicmp(data, "pass", 4) == 0) {
> +			break;
> +		case Opt_pass:
>  			if (!value) {
>  				vol->password = NULL;
>  				continue;
> @@ -961,8 +1138,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				}
>  				strcpy(vol->password, value);
>  			}
> -		} else if (!strnicmp(data, "ip", 2) ||
> -			   !strnicmp(data, "addr", 4)) {
> +			break;
> +		/* ip || addr */
> +		case Opt_ip:
> +		case Opt_addr:
>  			if (!value || !*value) {
>  				vol->UNCip = NULL;
>  			} else if (strnlen(value, INET6_ADDRSTRLEN) <
> @@ -973,54 +1152,70 @@ cifs_parse_mount_options(char *options, const char *devname,
>  						    "too long\n");
>  				return 1;
>  			}
> -		} else if (strnicmp(data, "sec", 3) == 0) {
> +			break;
> +		case Opt_sec:
>  			if (!value || !*value) {
>  				cERROR(1, "no security value specified");
>  				continue;
> -			} else if (strnicmp(value, "krb5i", 5) == 0) {
> +			}
> +			switch (match_token(value, cifs_sec_options, args)) {
> +			case Opt_sec_krb5i:
>  				vol->secFlg |= CIFSSEC_MAY_KRB5 |
>  					CIFSSEC_MUST_SIGN;
> -			} else if (strnicmp(value, "krb5p", 5) == 0) {
> +				break;
> +			case Opt_sec_krb5p:
>  				/* vol->secFlg |= CIFSSEC_MUST_SEAL |
>  					CIFSSEC_MAY_KRB5; */
>  				cERROR(1, "Krb5 cifs privacy not supported");
>  				return 1;
> -			} else if (strnicmp(value, "krb5", 4) == 0) {
> +			case Opt_sec_krb5:
>  				vol->secFlg |= CIFSSEC_MAY_KRB5;
> +				break;
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> -			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
> +			case Opt_sec_ntlmsspi:
>  				vol->secFlg |= CIFSSEC_MAY_NTLMSSP |
>  					CIFSSEC_MUST_SIGN;
> -			} else if (strnicmp(value, "ntlmssp", 7) == 0) {
> +				break;
> +			case Opt_sec_ntlmssp:
>  				vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
> +				break;
>  #endif
> -			} else if (strnicmp(value, "ntlmv2i", 7) == 0) {
> +			case Opt_sec_ntlmv2i:
>  				vol->secFlg |= CIFSSEC_MAY_NTLMV2 |
>  					CIFSSEC_MUST_SIGN;
> -			} else if (strnicmp(value, "ntlmv2", 6) == 0) {
> +				break;
> +			case Opt_sec_ntlmv2:
>  				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
> -			} else if (strnicmp(value, "ntlmi", 5) == 0) {
> +				break;
> +			case Opt_sec_ntlmi:
>  				vol->secFlg |= CIFSSEC_MAY_NTLM |
>  					CIFSSEC_MUST_SIGN;
> -			} else if (strnicmp(value, "ntlm", 4) == 0) {
> +				break;
> +			case Opt_sec_ntlm:
>  				/* ntlm is default so can be turned off too */
>  				vol->secFlg |= CIFSSEC_MAY_NTLM;
> -			} else if (strnicmp(value, "nontlm", 6) == 0) {
> +				break;
> +			case Opt_sec_nontlm:
>  				/* BB is there a better way to do this? */
>  				vol->secFlg |= CIFSSEC_MAY_NTLMV2;
> +				break;
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> -			} else if (strnicmp(value, "lanman", 6) == 0) {
> +			case Opt_sec_lanman:
>  				vol->secFlg |= CIFSSEC_MAY_LANMAN;
> +				break;
>  #endif
> -			} else if (strnicmp(value, "none", 4) == 0) {
> +			case Opt_sec_none:
>  				vol->nullauth = 1;
> -			} else {
> +				break;
> +			default:
>  				cERROR(1, "bad security option: %s", value);
>  				return 1;
>  			}
> -		} else if ((strnicmp(data, "unc", 3) == 0)
> -			   || (strnicmp(data, "target", 6) == 0)
> -			   || (strnicmp(data, "path", 4) == 0)) {
> +			break;
> +		/* unc || target || path */
> +		case Opt_unc:
> +		case Opt_target:
> +		case Opt_path:
>  			if (!value || !*value) {
>  				printk(KERN_WARNING "CIFS: invalid path to "
>  						    "network resource\n");
> @@ -1044,8 +1239,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				printk(KERN_WARNING "CIFS: UNC name too long\n");
>  				return 1;
>  			}
> -		} else if ((strnicmp(data, "domain", 3) == 0)
> -			   || (strnicmp(data, "workgroup", 5) == 0)) {
> +			break;
> +		/* domain || workgroup */
> +		case Opt_domain:
> +		case Opt_workgroup:
>  			if (!value || !*value) {
>  				printk(KERN_WARNING "CIFS: invalid domain name\n");
>  				return 1;	/* needs_arg; */
> @@ -1060,7 +1257,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  						    "long\n");
>  				return 1;
>  			}
> -		} else if (strnicmp(data, "prefixpath", 10) == 0) {
> +			break;
> +		case Opt_prefixpath:
>  			if (!value || !*value) {
>  				printk(KERN_WARNING
>  					"CIFS: invalid path prefix\n");
> @@ -1082,7 +1280,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				printk(KERN_WARNING "CIFS: prefix too long\n");
>  				return 1;
>  			}
> -		} else if (strnicmp(data, "iocharset", 9) == 0) {
> +			break;
> +		case Opt_iocharset:
>  			if (!value || !*value) {
>  				printk(KERN_WARNING "CIFS: invalid iocharset "
>  						    "specified\n");
> @@ -1099,58 +1298,72 @@ cifs_parse_mount_options(char *options, const char *devname,
>  						    "too long.\n");
>  				return 1;
>  			}
> -		} else if (!strnicmp(data, "uid", 3) && value && *value) {
> -			vol->linux_uid = simple_strtoul(value, &value, 0);
> -			uid_specified = true;
> -		} else if (!strnicmp(data, "forceuid", 8)) {
> +			break;
> +		case Opt_uid:
> +			if (value && *value) {
> +				vol->linux_uid =
> +					simple_strtoul(value, &value, 0);
> +				uid_specified = true;
> +			}
> +			break;
> +		case Opt_forceuid:
>  			override_uid = 1;
> -		} else if (!strnicmp(data, "noforceuid", 10)) {
> +			break;
> +		case Opt_noforceuid:
>  			override_uid = 0;
> -		} else if (!strnicmp(data, "gid", 3) && value && *value) {
> -			vol->linux_gid = simple_strtoul(value, &value, 0);
> -			gid_specified = true;
> -		} else if (!strnicmp(data, "forcegid", 8)) {
> -			override_gid = 1;
> -		} else if (!strnicmp(data, "noforcegid", 10)) {
> -			override_gid = 0;
> -		} else if (strnicmp(data, "file_mode", 4) == 0) {
> +			break;
> +		case Opt_gid:
>  			if (value && *value) {
> -				vol->file_mode =
> +				vol->linux_gid =
>  					simple_strtoul(value, &value, 0);
> +				gid_specified = true;
>  			}
> -		} else if (strnicmp(data, "dir_mode", 4) == 0) {
> +			break;
> +		case Opt_forcegid:
> +			override_gid = 1;
> +			break;
> +		case Opt_noforcegid:
> +			override_gid = 0;
> +			break;
> +		case Opt_file_mode:
>  			if (value && *value) {
> -				vol->dir_mode =
> +				vol->file_mode =
>  					simple_strtoul(value, &value, 0);
>  			}
> -		} else if (strnicmp(data, "dirmode", 4) == 0) {
> +			break;
> +		case Opt_dir_mode:
>  			if (value && *value) {
>  				vol->dir_mode =
>  					simple_strtoul(value, &value, 0);
>  			}
> -		} else if (strnicmp(data, "port", 4) == 0) {
> +			break;
> +		case Opt_port:
>  			if (value && *value) {
>  				vol->port =
>  					simple_strtoul(value, &value, 0);
>  			}
> -		} else if (strnicmp(data, "rsize", 5) == 0) {
> +			break;
> +		case Opt_rsize:
>  			if (value && *value) {
>  				vol->rsize =
>  					simple_strtoul(value, &value, 0);
>  			}
> -		} else if (strnicmp(data, "wsize", 5) == 0) {
> +			break;
> +		case Opt_wsize:
>  			if (value && *value) {
>  				vol->wsize =
>  					simple_strtoul(value, &value, 0);
>  			}
> -		} else if (strnicmp(data, "sockopt", 5) == 0) {
> +			break;
> +		case Opt_sockopt:
>  			if (!value || !*value) {
>  				cERROR(1, "no socket option specified");
>  				continue;
>  			} else if (strnicmp(value, "TCP_NODELAY", 11) == 0) {
>  				vol->sockopt_tcp_nodelay = 1;
>  			}
> -		} else if (strnicmp(data, "netbiosname", 4) == 0) {
> +			break;
> +		case Opt_netbiosname:
>  			if (!value || !*value || (*value == ' ')) {
>  				cFYI(1, "invalid (empty) netbiosname");
>  			} else {
> @@ -1173,7 +1386,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  					printk(KERN_WARNING "CIFS: netbiosname"
>  						" longer than 15 truncated.\n");
>  			}
> -		} else if (strnicmp(data, "servern", 7) == 0) {
> +			break;
> +		case Opt_servername:
>  			/* servernetbiosname specified override *SMBSERVER */
>  			if (!value || !*value || (*value == ' ')) {
>  				cFYI(1, "empty server netbiosname specified");
> @@ -1200,67 +1414,67 @@ cifs_parse_mount_options(char *options, const char *devname,
>  					printk(KERN_WARNING "CIFS: server net"
>  					"biosname longer than 15 truncated.\n");
>  			}
> -		} else if (strnicmp(data, "credentials", 4) == 0) {
> -			/* ignore */
> -		} else if (strnicmp(data, "version", 3) == 0) {
> -			/* ignore */
> -		} else if (strnicmp(data, "guest", 5) == 0) {
> -			/* ignore */
> -		} else if (strnicmp(data, "rw", 2) == 0) {
> -			/* ignore */
> -		} else if (strnicmp(data, "ro", 2) == 0) {
> -			/* ignore */
> -		} else if (strnicmp(data, "noblocksend", 11) == 0) {
> +			break;
> +		case Opt_noblocksend:
>  			vol->noblocksnd = 1;
> -		} else if (strnicmp(data, "noautotune", 10) == 0) {
> +			break;
> +		case Opt_noautotune:
>  			vol->noautotune = 1;
> -		} else if ((strnicmp(data, "suid", 4) == 0) ||
> -				   (strnicmp(data, "nosuid", 6) == 0) ||
> -				   (strnicmp(data, "exec", 4) == 0) ||
> -				   (strnicmp(data, "noexec", 6) == 0) ||
> -				   (strnicmp(data, "nodev", 5) == 0) ||
> -				   (strnicmp(data, "noauto", 6) == 0) ||
> -				   (strnicmp(data, "dev", 3) == 0)) {
> -			/*  The mount tool or mount.cifs helper (if present)
> -			    uses these opts to set flags, and the flags are read
> -			    by the kernel vfs layer before we get here (ie
> -			    before read super) so there is no point trying to
> -			    parse these options again and set anything and it
> -			    is ok to just ignore them */
> -			continue;
> -		} else if (strnicmp(data, "hard", 4) == 0) {
> +			break;
> +		/* hard || nosoft */
> +		case Opt_hard:
> +		case Opt_nosoft:
>  			vol->retry = 1;
> -		} else if (strnicmp(data, "soft", 4) == 0) {
> +			break;
> +		/* soft || nohard */
> +		case Opt_soft:
> +		case Opt_nohard:
>  			vol->retry = 0;
> -		} else if (strnicmp(data, "perm", 4) == 0) {
> +			break;
> +		case Opt_perm:
>  			vol->noperm = 0;
> -		} else if (strnicmp(data, "noperm", 6) == 0) {
> +			break;
> +		case Opt_noperm:
>  			vol->noperm = 1;
> -		} else if (strnicmp(data, "mapchars", 8) == 0) {
> +			break;
> +		case Opt_mapchars:
>  			vol->remap = 1;
> -		} else if (strnicmp(data, "nomapchars", 10) == 0) {
> +			break;
> +		case Opt_nomapchars:
>  			vol->remap = 0;
> -		} else if (strnicmp(data, "sfu", 3) == 0) {
> +			break;
> +		case Opt_sfu:
>  			vol->sfu_emul = 1;
> -		} else if (strnicmp(data, "nosfu", 5) == 0) {
> +			break;
> +		case Opt_nosfu:
>  			vol->sfu_emul = 0;
> -		} else if (strnicmp(data, "nodfs", 5) == 0) {
> +			break;
> +		case Opt_nodfs:
>  			vol->nodfs = 1;
> -		} else if (strnicmp(data, "posixpaths", 10) == 0) {
> +			break;
> +		case Opt_posixpaths:
>  			vol->posix_paths = 1;
> -		} else if (strnicmp(data, "noposixpaths", 12) == 0) {
> +			break;
> +		case Opt_noposixpaths:
>  			vol->posix_paths = 0;
> -		} else if (strnicmp(data, "nounix", 6) == 0) {
> +			break;
> +		case Opt_nounix:
>  			vol->no_linux_ext = 1;
> -		} else if (strnicmp(data, "nolinux", 7) == 0) {
> +			break;
> +		case Opt_nolinux:
>  			vol->no_linux_ext = 1;
> -		} else if ((strnicmp(data, "nocase", 6) == 0) ||
> -			   (strnicmp(data, "ignorecase", 10)  == 0)) {
> +			break;
> +		/* nocase || ignorecase */
> +		case Opt_nocase:
> +		case Opt_ignorecase:
>  			vol->nocase = 1;
> -		} else if (strnicmp(data, "brl", 3) == 0) {
> +			break;
> +		case Opt_brl:
>  			vol->nobrl =  0;
> -		} else if ((strnicmp(data, "nobrl", 5) == 0) ||
> -			   (strnicmp(data, "nolock", 6) == 0)) {
> +			break;
> +		/* nobrl || nolock */
> +		case Opt_nobrl:
> +		case Opt_nolock:
>  			vol->nobrl =  1;
>  			/* turn off mandatory locking in mode
>  			if remote locking is turned off since the
> @@ -1268,8 +1482,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  			if (vol->file_mode ==
>  				(S_IALLUGO & ~(S_ISUID | S_IXGRP)))
>  				vol->file_mode = S_IALLUGO;
> -		} else if (strnicmp(data, "forcemandatorylock", 9) == 0) {
> -			/* will take the shorter form "forcemand" as well */
> +			break;
> +		case Opt_forcemandatorylock:
>  			/* This mount option will force use of mandatory
>  			  (DOS/Windows style) byte range locks, instead of
>  			  using posix advisory byte range locks, even if the
> @@ -1279,61 +1493,98 @@ cifs_parse_mount_options(char *options, const char *devname,
>  			  would be used (mandatory locks is all that those
>  			  those servers support) */
>  			vol->mand_lock = 1;
> -		} else if (strnicmp(data, "setuids", 7) == 0) {
> +			break;
> +		case Opt_setuids:
>  			vol->setuids = 1;
> -		} else if (strnicmp(data, "nosetuids", 9) == 0) {
> +			break;
> +		case Opt_nosetuids:
>  			vol->setuids = 0;
> -		} else if (strnicmp(data, "dynperm", 7) == 0) {
> +			break;
> +		case Opt_dynperm:
>  			vol->dynperm = true;
> -		} else if (strnicmp(data, "nodynperm", 9) == 0) {
> +			break;
> +		case Opt_nodynperm:
>  			vol->dynperm = false;
> -		} else if (strnicmp(data, "nohard", 6) == 0) {
> -			vol->retry = 0;
> -		} else if (strnicmp(data, "nosoft", 6) == 0) {
> -			vol->retry = 1;
> -		} else if (strnicmp(data, "nointr", 6) == 0) {
> -			vol->intr = 0;
> -		} else if (strnicmp(data, "intr", 4) == 0) {
> +			break;
> +		case Opt_intr:
>  			vol->intr = 1;
> -		} else if (strnicmp(data, "nostrictsync", 12) == 0) {
> -			vol->nostrictsync = 1;
> -		} else if (strnicmp(data, "strictsync", 10) == 0) {
> +			break;
> +		case Opt_nointr:
> +			vol->intr = 0;
> +			break;
> +		case Opt_strictsync:
>  			vol->nostrictsync = 0;
> -		} else if (strnicmp(data, "serverino", 7) == 0) {
> +			break;
> +		case Opt_nostrictsync:
> +			vol->nostrictsync = 1;
> +			break;
> +		case Opt_serverino:
>  			vol->server_ino = 1;
> -		} else if (strnicmp(data, "noserverino", 9) == 0) {
> +			break;
> +		case Opt_noserverino:
>  			vol->server_ino = 0;
> -		} else if (strnicmp(data, "cifsacl", 7) == 0) {
> +			break;
> +		case Opt_cifsacl:
>  			vol->cifs_acl = 1;
> -		} else if (strnicmp(data, "nocifsacl", 9) == 0) {
> +			break;
> +		case Opt_nocifsacl:
>  			vol->cifs_acl = 0;
> -		} else if (strnicmp(data, "acl", 3) == 0) {
> +			break;
> +		case Opt_acl:
>  			vol->no_psx_acl = 0;
> -		} else if (strnicmp(data, "noacl", 5) == 0) {
> +			break;
> +		case Opt_noacl:
>  			vol->no_psx_acl = 1;
> +			break;
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> -		} else if (strnicmp(data, "locallease", 6) == 0) {
> +		case Opt_locallease:
>  			vol->local_lease = 1;
> +			break;
>  #endif
> -		} else if (strnicmp(data, "sign", 4) == 0) {
> +		case Opt_sign:
>  			vol->secFlg |= CIFSSEC_MUST_SIGN;
> -		} else if (strnicmp(data, "seal", 4) == 0) {
> +			break;
> +		case Opt_seal:
>  			/* we do not do the following in secFlags because seal
>  			   is a per tree connection (mount) not a per socket
>  			   or per-smb connection option in the protocol */
>  			/* vol->secFlg |= CIFSSEC_MUST_SEAL; */
>  			vol->seal = 1;
> -		} else if (strnicmp(data, "direct", 6) == 0) {
> -			vol->direct_io = 1;
> -		} else if (strnicmp(data, "forcedirectio", 13) == 0) {
> +			break;
> +		/* direct || forcedirectio */
> +		case Opt_direct:
> +		case Opt_forcedirectio:
>  			vol->direct_io = 1;
> -		} else if (strnicmp(data, "noac", 4) == 0) {
> +			break;
> +		case Opt_noac:
>  			printk(KERN_WARNING "CIFS: Mount option noac not "
>  				"supported. Instead set "
>  				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
> -		} else
> +			break;
> +		/* Ignore these */
> +		case Opt_credentials:
> +		case Opt_version:
> +		case Opt_guest:
> +		case Opt_ro:
> +		case Opt_rw:
> +		/*  The mount tool or mount.cifs helper (if present) uses these
> +		    opts to set flags, and the flags are read by the kernel vfs
> +		    layer before we get here (ie before read super) so there is
> +		    no point trying to parse these options again and set
> +		    anything and it is ok to just ignore them */
> +		case Opt_suid:
> +		case Opt_nosuid:
> +		case Opt_exec:
> +		case Opt_noexec:
> +		case Opt_dev:
> +		case Opt_nodev:
> +		case Opt_noauto:
> +			break;
> +		default:
>  			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
>  						data);
> +			break;
> +		}
>  	}
>  	if (vol->UNC == NULL) {
>  		if (devname == NULL) {

Finally got around to trying this out and I get the following oops when
mounting a share with these options:

    sec=krb5i,multises,noauto

general protection fault: 0000 [#1] SMP 
last sysfs file: /sys/devices/virtual/bdi/cifs-1/uevent
CPU 0 
Modules linked in: cifs nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc ipv6 microcode i2c_piix4 i2c_core virtio_net joydev virtio_balloon virtio_blk virtio_pci virtio_ring virtio [last unloaded: mperf]

Pid: 1542, comm: mount.cifs Not tainted 2.6.35-0.2.rc3.git0.fc14.x86_64 #1 /
RIP: 0010:[<ffffffff8123728c>]  [<ffffffff8123728c>] strchr+0x14/0x1d
RSP: 0018:ffff880039a65bd8  EFLAGS: 00010246
RAX: 7365735f626d735f RBX: 0000000000000000 RCX: ffff88003cb4d041
RDX: ffff880039a65c6d RSI: 0000000000000025 RDI: 7365735f626d735f
RBP: ffff880039a65bd8 R08: 000000000000002c R09: 000000000000002c
R10: 00000000000080d0 R11: ffffffff8113bc6c R12: ffff88003cb4d041
R13: ffffffffa0219d40 R14: 0000000000000000 R15: 7365735f626d735f
FS:  00007f1fbcba6720(0000) GS:ffff880004600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000001a31818 CR3: 000000003a287000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount.cifs (pid: 1542, threadinfo ffff880039a64000, task ffff880039adc8a0)
Stack:
 ffff880039a65c48 ffffffff8123b1ee ffff88003a18b990 ffff880039a65cd8
<0> ffff88003cb4d041 ffffffff8111cd42 ffffffffa0202f86 7365735f626d735f
<0> ffff88003997de30 ffff88003997de30 ffff88003cc94840 00000000ffffffff
Call Trace:
 [<ffffffff8123b1ee>] match_token+0x4b/0x1a8
 [<ffffffff8111cd42>] ? __kmalloc+0x17c/0x18e
 [<ffffffffa0202f86>] ? cifs_mount+0x639/0x1737 [cifs]
 [<ffffffffa0202c11>] cifs_mount+0x2c4/0x1737 [cifs]
 [<ffffffffa01f5aa4>] ? cifs_get_sb+0x110/0x2e4 [cifs]
 [<ffffffffa01f5b00>] cifs_get_sb+0x16c/0x2e4 [cifs]
 [<ffffffff8112c946>] vfs_kern_mount+0xbd/0x19b
 [<ffffffff8112ca8c>] do_kern_mount+0x4d/0xed
 [<ffffffff8114368a>] do_mount+0x776/0x7ed
 [<ffffffff811128aa>] ? alloc_pages_current+0xa7/0xca
 [<ffffffff81143789>] sys_mount+0x88/0xc2
 [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
Code: 14 84 c0 74 0e 48 ff c7 48 ff c6 48 ff ca 48 85 d2 75 e1 31 c0 c9 c3 55 48 89 f8 48 89 e5 eb 0b 84 d2 75 04 31 c0 eb 0a 48 ff c0 <8a> 10 40 38 f2 75 ee c9 c3 55 48 89 f8 48 89 e5 eb 03 48 ff c0 
RIP  [<ffffffff8123728c>] strchr+0x14/0x1d
 RSP <ffff880039a65bd8>
---[ end trace 50d173d44b64b1d9 ]---

It's crashing in this match_token() call:

gdb) list *(cifs_mount+0x2c4)
0xdcf7 is in cifs_mount (fs/cifs/connect.c:1094).
1089		while ((data = strsep(&options, separator)) != NULL) {
1090			if (!*data)
1091				continue;
1092			if ((value = strchr(data, '=')) != NULL)
1093				*value++ = '\0';
1094			switch (match_token(data, cifs_mount_options, args)) {
1095			case Opt_user_xattr:
1096				vol->no_xattr = 0;
1097				break;
1098			case Opt_nouser_xattr:
(gdb) quit

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
