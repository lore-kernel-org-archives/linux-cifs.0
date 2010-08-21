From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: infrastructure for stashing passwords in
 keyring
Date: Sat, 21 Aug 2010 06:53:17 -0400
Message-ID: <20100821065317.46d2d8de@tlielax.poochiereds.net>
References: <1282249633-27756-1-git-send-email-jaxbrigs@gmail.com>
	<1282249633-27756-2-git-send-email-jaxbrigs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282249633-27756-2-git-send-email-jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Aug 2010 00:27:13 +0400
Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This is a kernel part of a new infrastructure for stashing passwords
> in kernel keyring per user basis. Keys of "user" type with passwords
> are protected from disclosure and stored in uid-specific keyring.
> Search is happens according to the key description in format
> cifscreds:ip:username:[domainname]. In a case if user has given
> credentials otherwise search doesn't happen.
> 
> Signed-off-by: Igor Druzhinin  <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/Makefile    |    2 +-
>  fs/cifs/cifscreds.c |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifscreds.h |   34 +++++++++
>  fs/cifs/connect.c   |   13 ++++
>  4 files changed, 240 insertions(+), 1 deletions(-)
>  create mode 100644 fs/cifs/cifscreds.c
>  create mode 100644 fs/cifs/cifscreds.h
> 
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index adefa60..babab37 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -6,7 +6,7 @@ obj-$(CONFIG_CIFS) += cifs.o
>  cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
>  	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
>  	  md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
> -	  readdir.o ioctl.o sess.o export.o cifsacl.o
> +	  readdir.o ioctl.o sess.o export.o cifsacl.o cifscreds.o
>  
>  cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o
>  
> diff --git a/fs/cifs/cifscreds.c b/fs/cifs/cifscreds.c
> new file mode 100644
> index 0000000..828631f
> --- /dev/null
> +++ b/fs/cifs/cifscreds.c
> @@ -0,0 +1,192 @@
> +/*
> + *   fs/cifs/cifscreds.c - CIFS credentinals stashing rountine
> + *
> + *   Copyright (c) 2010 Igor Druzhinin
> + *   Copyright (c) 2010 Jeff Layton
> + *   Author(s): Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *		Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
> + *
> + *   You should have received a copy of the GNU Lesser General Public License
> + *   along with this library; if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/inet.h>
> +#include <linux/key.h>
> +#include <linux/keyctl.h>
> +#include <linux/key-type.h>
> +#include <keys/keyring-type.h>
> +#include <keys/user-type.h>
> +#include "cifsglob.h"
> +#include "cifs_debug.h"
> +#include "cifscreds.h"
> +
> +/* create key description from given credentials */
> +static char *
> +create_key_description(const char *addr, const char *user,
> +			const char *domain, char *desc)
> +{
> +	char *str_end;
> +	int str_len;
> +
> +	sprintf(desc, "%s:%s:%s:", CIFSCREDS_PROG_NAME, addr, user);
> +
> +	if (domain != NULL) {
> +		str_end = desc + strlen(desc);
> +		str_len = strlen(domain);
> +		while (str_len--) {
> +			*str_end = tolower(*domain++);
> +			str_end++;
> +		}
> +		*str_end = '\0';
> +	}
> +
> +	return desc;
> +}
> +
> +/*
> + * searching for requested key in the uid or session specific keyring
> + * according to DEST_KEYRING macro. After all operations with key caller
> + * must do key_put()
> + */
> +static struct key *
> +cifs_key_search(const char *addr, const char *user, const char *domain)
> +{
> +	char *desc;
> +	struct key *keyring, *key;
> +	struct keyring_list *klist;
> +	int loop;
> +
> +	switch (DEST_KEYRING) {
> +	case KEY_SPEC_USER_KEYRING:
> +		keyring = current_user()->uid_keyring;
> +		break;
> +
> +	case KEY_SPEC_SESSION_KEYRING:
> +		keyring = current_user()->session_keyring;
> +		break;
> +
> +	default:
> +		printk(KERN_WARNING "CIFS creds: unsupported keyring\n");
> +		return NULL;
> +	}
> +	if (keyring == NULL) {
> +		cFYI(1, "CIFS creds: keyring is not installed");
> +		return NULL;
> +	}
> +
> +	desc = kmalloc(INET6_ADDRSTRLEN + 200 + 256 + \
> +			sizeof(CIFSCREDS_PROG_NAME) + 3, GFP_KERNEL);

There are a lot of magic numbers in the above. I think these should be
turned into #define'd constants. Alternately, you could declare a
"DESC_LENGTH" near the top of the file and add a comment that describes
what each piece of the length refers to.

> +	if (desc == NULL) {
> +		printk(KERN_WARNING "CIFS creds: no memory for description\n");
> +		return NULL;
> +	}
> +
> +	create_key_description(addr, user, domain, desc);
> +	cFYI(1, "CIFS creds: key description: %s for uid:%d",
> +		desc, current_uid());
> +
> +	klist = rcu_dereference_protected(keyring->payload.subscriptions,
> +		rwsem_is_locked((struct rw_semaphore *)&keyring->sem));
> +	if (klist) {
> +		for (loop = 0; loop < klist->nkeys; loop++) {
> +			key = klist->keys[loop];
> +
> +			if (key->type == &key_type_user &&
> +				(!key->type->match ||
> +				key->type->match(key, desc)) &&
> +				!test_bit(KEY_FLAG_REVOKED, &key->flags)
> +			)
> +				goto key_search_found;
> +		}
> +	}

I'm not clear on the need for the above loop -- is there some reason
to not just use request_key() here? If you're concerned about limiting
the search to specific keyrings, then there may be interfaces that
handle that already or they can be added to the keyring code. I'm not
convinced that we need to worry about that however.

> +	kfree(desc);
> +	return NULL;
> +
> +key_search_found:
> +	atomic_inc(&key->usage);
> +	kfree(desc);
> +	return key;
> +}
> +
> +/* read and copy key data to kernel buffer */
> +static long cifs_key_read(const struct key *key, char *buffer, size_t buflen)
> +{
> +	struct user_key_payload *upayload;
> +	long ret;
> +
> +	upayload = rcu_dereference_protected(key->payload.data,
> +		rwsem_is_locked(&((struct key *)key)->sem));
> +	ret = upayload->datalen;
> +

You have a reference to the key here, right? Is there any need for the
rcu stuff above?

> +	/* we can return the data as is */
> +	if (buffer && buflen > 0) {
> +		if (buflen > upayload->datalen)
> +			buflen = upayload->datalen;
> +
> +		if (memcpy(buffer, upayload->data, buflen) == NULL)
> +			ret = -EFAULT;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * cifs_get_key_password - Reading password from the keyring
> + *		according to provided description.
> + * @addr: IP address of target server.
> + * @user: Name of the intrested user.
> + * @domain: Possible domain name. Can be NULL.
> + *
> + * Returns the pointer to password or NULL, and the caller is
> + * responsible for freeing it.
> + */
> +char *
> +cifs_get_key_password(const char *addr, const char *user, const char *domain)
> +{
> +	struct key *pass_key;
> +	char *key_password = NULL;
> +	long pass_len;
> +
> +	pass_key = cifs_key_search(addr, user, domain);
> +	if (pass_key == NULL) {
> +		cFYI(1, "CIFS creds: Appropriate key for %s not found",	addr);
> +		return NULL;
> +	}
> +
> +	pass_len = cifs_key_read(pass_key, NULL, 0);
> +	if (pass_len == 0) {
> +		cFYI(1, "CIFS creds: Password key for %s is empty", addr);
> +		goto no_key_password;
> +	}
> +
> +	key_password = kzalloc(pass_len, GFP_KERNEL);
> +	if (key_password == NULL) {
> +		printk(KERN_WARNING "CIFS creds: no memory for password\n");
> +		goto no_key_password;
> +	}
> +
> +	pass_len = cifs_key_read(pass_key, key_password, pass_len);
> +	if (pass_len < 0) {
> +		printk(KERN_WARNING "CIFS creds: unable to read key's "
> +			"payload for %s\n", addr);
> +		kzfree(key_password);
> +		key_password = NULL;
> +	}
> +
> +no_key_password:
> +	key_put(pass_key);
> +	return key_password;
> +}
> diff --git a/fs/cifs/cifscreds.h b/fs/cifs/cifscreds.h
> new file mode 100644
> index 0000000..466ecf9
> --- /dev/null
> +++ b/fs/cifs/cifscreds.h
> @@ -0,0 +1,34 @@
> +/*
> + *   fs/cifs/cifscreds.c - CIFS credentinals stashing rountine definition
> + *
> + *   Copyright (c) 2010 Igor Druzhinin
> + *   Copyright (c) 2010 Jeff Layton
> + *   Author(s): Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *		Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
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
> + *
> + *   You should have received a copy of the GNU Lesser General Public License
> + *   along with this library; if not, write to the Free Software
> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +#ifndef _CIFSCREDS_H
> +#define _CIFSCREDS_H
> +
> +#include <linux/keyctl.h>
> +
> +#define CIFSCREDS_PROG_NAME "cifscreds"
> +#define DEST_KEYRING KEY_SPEC_USER_KEYRING
> +
> +extern char *
> +cifs_get_key_password(const char *addr,	const char *user, const char *domain);
> +
> +#endif /* _CIFSCREDS_H */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 95c2ea6..ef4371e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -49,6 +49,7 @@
>  #include "rfc1002pdu.h"
>  #include "cn_cifs.h"
>  #include "fscache.h"
> +#include "cifscreds.h"
>  
>  #define CIFS_PORT 445
>  #define RFC1001_PORT 139
> @@ -2568,6 +2569,7 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>  	struct TCP_Server_Info *srvTcp;
>  	char   *full_path;
>  	char *mount_data = mount_data_global;
> +	char *key_password;
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  	struct dfs_info3_param *referrals = NULL;
>  	unsigned int num_referrals = 0;
> @@ -2622,6 +2624,17 @@ try_mount_again:
>  	}
>  	cifs_sb->local_nls = volume_info->local_nls;
>  
> +	/* search for key with password and read its payload */
> +	if (volume_info->password == NULL &&
> +		!(volume_info->secFlg & CIFSSEC_MAY_KRB5)
> +	) {
> +		key_password = cifs_get_key_password(volume_info->UNCip,
> +						volume_info->username,
> +						volume_info->domainname);
> +		if (key_password != NULL)
> +			volume_info->password = key_password;
> +	}
> +
>  	/* get a reference to a tcp session */
>  	srvTcp = cifs_get_tcp_session(volume_info);
>  	if (IS_ERR(srvTcp)) {

Would it be better to put the above into CIFS_SessSetup() instead? Maybe
add a static helper function does all of the above in sess.c and have
each authtype that would need a password call that function to set the
smb session password?

That may make it easier to integrate this into the multiuser mount code
later too.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
