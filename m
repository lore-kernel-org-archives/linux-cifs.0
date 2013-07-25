From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 1/2] cifs: Move string length definitions to uapi
Date: Thu, 25 Jul 2013 13:55:58 -0400
Message-ID: <20130725135558.43d88c96@tlielax.poochiereds.net>
References: <1374773721-24394-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, gang.chen@asianux.com,
	samba-technical@lists.samba.org
To: scott.lovenberg@gmail.com
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1374773721-24394-1-git-send-email-scott.lovenberg@gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 25 Jul 2013 13:35:20 -0400
scott.lovenberg@gmail.com wrote:

> From: Scott Lovenberg <scott.lovenberg@gmail.com>
> 
> The string lengths for username, domainname, password and share have
> been moved into their own header file in uapi so the mount helper can
> use autoconf to define the size of the string lengths instead of
> trying to keep the two in sync manually.  The names have also been
> changed to be more easily understood, using the "CIFS" prefix and "LEN"
> suffix rather than "SIZE" which could be confusing.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
> ---
>  fs/cifs/AUTHORS                      |  2 ++
>  fs/cifs/cifsencrypt.c                |  2 +-
>  fs/cifs/cifsglob.h                   |  7 ++-----
>  fs/cifs/connect.c                    | 20 ++++++++++----------
>  fs/cifs/sess.c                       | 16 ++++++++--------
>  include/uapi/linux/cifs/cifs_mount.h | 25 +++++++++++++++++++++++++
>  6 files changed, 48 insertions(+), 24 deletions(-)
>  create mode 100644 include/uapi/linux/cifs/cifs_mount.h
> 
> diff --git a/fs/cifs/AUTHORS b/fs/cifs/AUTHORS
> index ea940b1..6804e2d 100644
> --- a/fs/cifs/AUTHORS
> +++ b/fs/cifs/AUTHORS
> @@ -39,6 +39,8 @@ Shaggy (Dave Kleikamp) for innumerable small fs suggestions and some good cleanu
>  Gunter Kukkukk (testing and suggestions for support of old servers)
>  Igor Mammedov (DFS support)
>  Jeff Layton (many, many fixes, as well as great work on the cifs Kerberos code)
> +Scott Lovenberg
> +
>  
>  Test case and Bug Report contributors
>  -------------------------------------
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index bb84d7c..194f9cc 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -421,7 +421,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  		if (blobptr + attrsize > blobend)
>  			break;
>  		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
> -			if (!attrsize || attrsize >= MAX_DOMAINNAME_SIZE)
> +			if (!attrsize || attrsize >= CIFS_MAX_DOMAINNAME_LEN)
>  				break;
>  			if (!ses->domainName) {
>  				ses->domainName =
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 64bb4c5..b07b122 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -28,6 +28,7 @@
>  #include "cifsacl.h"
>  #include <crypto/internal/hash.h>
>  #include <linux/scatterlist.h>
> +#include <uapi/linux/cifs/cifs_mount.h>
>  #ifdef CONFIG_CIFS_SMB2
>  #include "smb2pdu.h"
>  #endif
> @@ -41,12 +42,8 @@
>  #define MAX_SES_INFO 2
>  #define MAX_TCON_INFO 4
>  
> -#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
> +#define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + CIFS_MAX_SHARE_LEN + 1)
>  #define MAX_SERVER_SIZE 15
		^^^^^^^
This looks wrong too. IIUC, that should be the max length of the
"server" portion of the field. The fact that MAX_TREE_SIZE is pretty
long is likely what papers over this...

The userland helper uses NI_MAXHOST for this field, but that's not
defined in the kernel. Perhaps this should be given a name like
CIFS_NI_MAXHOST, and expanded to the same size as the mount helper uses
(1025)?

> -#define MAX_SHARE_SIZE 80
> -#define MAX_DOMAINNAME_SIZE 256	/* maximum fully qualified domain name (FQDN) */
> -#define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
> -#define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
>  
>  #define CIFS_MIN_RCV_POOL 4
>  
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 3f9dcf7..20ac9d4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1575,8 +1575,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (strnlen(string, MAX_USERNAME_SIZE) >
> -							MAX_USERNAME_SIZE) {
> +			if (strnlen(string, CIFS_MAX_USERNAME_LEN) >
> +							CIFS_MAX_USERNAME_LEN) {
>  				printk(KERN_WARNING "CIFS: username too long\n");
>  				goto cifs_parse_mount_err;
>  			}
> @@ -1675,8 +1675,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			if (string == NULL)
>  				goto out_nomem;
>  
> -			if (strnlen(string, MAX_DOMAINNAME_SIZE)
> -					== MAX_DOMAINNAME_SIZE) {
> +			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
> +					== CIFS_MAX_DOMAINNAME_LEN) {
>  				printk(KERN_WARNING "CIFS: domain name too"
>  						    " long\n");
>  				goto cifs_parse_mount_err;
> @@ -2221,13 +2221,13 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
>  		/* anything else takes username/password */
>  		if (strncmp(ses->user_name,
>  			    vol->username ? vol->username : "",
> -			    MAX_USERNAME_SIZE))
> +			    CIFS_MAX_USERNAME_LEN))
>  			return 0;
>  		if (strlen(vol->username) != 0 &&
>  		    ses->password != NULL &&
>  		    strncmp(ses->password,
>  			    vol->password ? vol->password : "",
> -			    MAX_PASSWORD_SIZE))
> +			    CIFS_MAX_PASSWORD_LEN))
>  			return 0;
>  	}
>  	return 1;
> @@ -2277,8 +2277,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>  
>  #ifdef CONFIG_KEYS
>  
> -/* strlen("cifs:a:") + MAX_DOMAINNAME_SIZE + 1 */
> -#define CIFSCREDS_DESC_SIZE (7 + MAX_DOMAINNAME_SIZE + 1)
> +/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
> +#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
>  
>  /* Populate username and pw fields from keyring if possible */
>  static int
> @@ -2352,7 +2352,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>  	}
>  
>  	len = delim - payload;
> -	if (len > MAX_USERNAME_SIZE || len <= 0) {
> +	if (len > CIFS_MAX_USERNAME_LEN || len <= 0) {
>  		cifs_dbg(FYI, "Bad value from username search (len=%zd)\n",
>  			 len);
>  		rc = -EINVAL;
> @@ -2369,7 +2369,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>  	cifs_dbg(FYI, "%s: username=%s\n", __func__, vol->username);
>  
>  	len = key->datalen - (len + 1);
> -	if (len > MAX_PASSWORD_SIZE || len <= 0) {
> +	if (len > CIFS_MAX_PASSWORD_LEN || len <= 0) {
>  		cifs_dbg(FYI, "Bad len for password search (len=%zd)\n", len);
>  		rc = -EINVAL;
>  		kfree(vol->username);
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 57b1537..a0a62db 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -197,7 +197,7 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
>  		bytes_ret = 0;
>  	} else
>  		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
> -					    MAX_DOMAINNAME_SIZE, nls_cp);
> +					    CIFS_MAX_DOMAINNAME_LEN, nls_cp);
>  	bcc_ptr += 2 * bytes_ret;
>  	bcc_ptr += 2;  /* account for null terminator */
>  
> @@ -226,7 +226,7 @@ static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
>  		*(bcc_ptr+1) = 0;
>  	} else {
>  		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->user_name,
> -					    MAX_USERNAME_SIZE, nls_cp);
> +					    CIFS_MAX_USERNAME_LEN, nls_cp);
>  	}
>  	bcc_ptr += 2 * bytes_ret;
>  	bcc_ptr += 2; /* account for null termination */
> @@ -246,8 +246,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
>  	/* BB what about null user mounts - check that we do this BB */
>  	/* copy user */
>  	if (ses->user_name != NULL) {
> -		strncpy(bcc_ptr, ses->user_name, MAX_USERNAME_SIZE);
> -		bcc_ptr += strnlen(ses->user_name, MAX_USERNAME_SIZE);
> +		strncpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
> +		bcc_ptr += strnlen(ses->user_name, CIFS_MAX_USERNAME_LEN);
>  	}
>  	/* else null user mount */
>  	*bcc_ptr = 0;
> @@ -255,8 +255,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
>  
>  	/* copy domain */
>  	if (ses->domainName != NULL) {
> -		strncpy(bcc_ptr, ses->domainName, MAX_DOMAINNAME_SIZE);
> -		bcc_ptr += strnlen(ses->domainName, MAX_DOMAINNAME_SIZE);
> +		strncpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
> +		bcc_ptr += strnlen(ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
>  	} /* else we will send a null domain name
>  	     so the server will default to its own domain */
>  	*bcc_ptr = 0;
> @@ -501,7 +501,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	} else {
>  		int len;
>  		len = cifs_strtoUTF16((__le16 *)tmp, ses->domainName,
> -				      MAX_USERNAME_SIZE, nls_cp);
> +				      CIFS_MAX_USERNAME_LEN, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
>  		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->DomainName.Length = cpu_to_le16(len);
> @@ -517,7 +517,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  	} else {
>  		int len;
>  		len = cifs_strtoUTF16((__le16 *)tmp, ses->user_name,
> -				      MAX_USERNAME_SIZE, nls_cp);
> +				      CIFS_MAX_USERNAME_LEN, nls_cp);
>  		len *= 2; /* unicode is 2 bytes each */
>  		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
>  		sec_blob->UserName.Length = cpu_to_le16(len);
> diff --git a/include/uapi/linux/cifs/cifs_mount.h b/include/uapi/linux/cifs/cifs_mount.h
> new file mode 100644
> index 0000000..1485781
> --- /dev/null
> +++ b/include/uapi/linux/cifs/cifs_mount.h
> @@ -0,0 +1,25 @@
> +/*
> + *   include/uapi/linux/cifs/cifs_mount.h
> + *
> + *   Author(s): Scott Lovenberg (scott.lovenberg@gmail.com)
> + *
> + *   This library is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU Lesser General Public License as published
> + *   by the Free Software Foundation; either version 2.1 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This library is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
> + *   the GNU Lesser General Public License for more details.
> + */
> +#ifndef _CIFS_MOUNT_H
> +#define _CIFS_MOUNT_H
> +
> +/* Max string lengths for cifs mounting options. */
> +#define CIFS_MAX_DOMAINNAME_LEN 256 /* max fully qualified domain name */
> +#define CIFS_MAX_USERNAME_LEN   256 /* reasonable max for current servers */
> +#define CIFS_MAX_PASSWORD_LEN   512 /* Windows max seems to be 256 wide chars */
> +#define CIFS_MAX_SHARE_LEN 80
> +
> +#endif /* _CIFS_MOUNT_H */

...other than the above, this looks reasonable to me.

-- 
Jeff Layton <jlayton@redhat.com>
