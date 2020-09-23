Return-Path: <SRS0=1fPB=DA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E0CC2D0A8
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Sep 2020 13:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9FD221F0
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Sep 2020 13:56:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DUDcR/70"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWN4a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:56:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:49048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWN4a (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Sep 2020 09:56:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600869388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zcoTu+a8alJcmTsZ5n6l439ICCBUt2mjAveOy+f3ihM=;
        b=DUDcR/70gE7bx6AnHTCoWapt4VDDyIf7KvovT2tljCUYmfNPa5Qo7Lcp2al/FhJIny0jI5
        7iXtsk1St7rY4X4kezkwE2MvZnWFjrYyPbQO3+VVDqxJmNkte0OD3sIP5BDSr9lyGR7R58
        bHwQwll3mrwyW1qLnH7kZZz0ij0dkpU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DA6A4AC26;
        Wed, 23 Sep 2020 13:57:05 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
In-Reply-To: <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com>
 <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com>
 <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com>
 <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com>
 <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
Date:   Wed, 23 Sep 2020 15:56:27 +0200
Message-ID: <874knolhpw.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Also, I'll test this out with DFS once I figure out how to set it up. :)
> Re-attaching the patch with some minor changes with just the
> "force_pam" mount option.

You will need 2 Windows VM. DFS is basically symlinks across
servers. The DFS root VM will host the links (standalone namespace) and
you have to make them point to shares on the 2nd VM. You don't need to
setup replication to test.

When you mount the root in cifs.ko and access a link, the server will
reply that the file is remote. cifs.ko then does an FSCTL on the link to
resolve the target it points to and then connects to the target and
mounts it under the link seemlessly.


Regarding the patch:

* need to update the man page with option and explanation

I have some comments with the style, I know it's annoying.. but it
would be best to keep the same across the code.

* use the existing indent style (tabs) and avoid adding trailing whitespace=
s.
* no () for return statements
* no casting for memory allocation
* if (X) free(X)  =3D> free(X)

Below some comments about pam_auth_krb5_conv():

> @@ -1809,6 +1824,119 @@ get_password(const char *prompt, char *input, int=
 capacity)
>  	return input;
>  }
>=20=20
> +#ifdef HAVE_KRB5PAM
> +#define PAM_CIFS_SERVICE "cifs"
> +
> +static int
> +pam_auth_krb5_conv(int n, const struct pam_message **msg,
> +    struct pam_response **resp, void *data)
> +{
> +    struct parsed_mount_info *parsed_info;
> +	struct pam_response *reply;
> +	int i;
> +
> +	*resp =3D NULL;
> +
> +    parsed_info =3D data;
> +    if (parsed_info =3D=3D NULL)
> +		return (PAM_CONV_ERR);
> +	if (n <=3D 0 || n > PAM_MAX_NUM_MSG)
> +		return (PAM_CONV_ERR);
> +
> +	if ((reply =3D calloc(n, sizeof(*reply))) =3D=3D NULL)
> +		return (PAM_CONV_ERR);
> +
> +	for (i =3D 0; i < n; ++i) {
> +		switch (msg[i]->msg_style) {
> +		case PAM_PROMPT_ECHO_OFF:
> +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE + 1=
)) =3D=3D NULL)
> +                goto fail;
> +
> +            if (parsed_info->got_password && parsed_info->password !=3D =
NULL) {
> +                strncpy(reply[i].resp, parsed_info->password, MOUNT_PASS=
WD_SIZE + 1);
> +            } else if (get_password(msg[i]->msg, reply[i].resp, MOUNT_PA=
SSWD_SIZE + 1) =3D=3D NULL) {
> +                goto fail;
> +            }
> +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> +
> +			reply[i].resp_retcode =3D PAM_SUCCESS;
> +			break;
> +		case PAM_PROMPT_ECHO_ON:
> +			fprintf(stderr, "%s: ", msg[i]->msg);
> +            if ((reply[i].resp =3D (char *) malloc(MOUNT_PASSWD_SIZE + 1=
)) =3D=3D NULL)
> +                goto fail;
> +
> +			if (fgets(reply[i].resp, MOUNT_PASSWD_SIZE + 1, stdin) =3D=3D NULL)

Do we need to remove the trailing \n from the buffer?

> +                goto fail;
> +
> +            reply[i].resp[MOUNT_PASSWD_SIZE] =3D '\0';
> +
> +			reply[i].resp_retcode =3D PAM_SUCCESS;
> +			break;
> +		case PAM_ERROR_MSG:

Shouldn't this PAM_ERROR_MSG case goto fail?

> +		case PAM_TEXT_INFO:
> +			fprintf(stderr, "%s: ", msg[i]->msg);
> +
> +			reply[i].resp_retcode =3D PAM_SUCCESS;
> +			break;
> +		default:
> +			goto fail;
> +		}
> +	}
> +	*resp =3D reply;
> +	return (PAM_SUCCESS);
> +
> + fail:
> +	for(i =3D 0; i < n; i++) {
> +        if (reply[i].resp)
> +            free(reply[i].resp);

free(NULL) is a no-op, remove the checks.

> +	}
> +	free(reply);
> +	return (PAM_CONV_ERR);
> +}

I gave this a try with a properly configured system joined to AD from
local root account:

aaptel$ ./configure
...
checking krb5.h usability... yes
checking krb5.h presence... yes
checking for krb5.h... yes
checking krb5/krb5.h usability... yes
checking krb5/krb5.h presence... yes
checking for krb5/krb5.h... yes
checking for keyvalue in krb5_keyblock... no
...
checking keyutils.h usability... yes
checking keyutils.h presence... yes
checking for keyutils.h... yes
checking for krb5_init_context in -lkrb5... yes
...
checking for WBCLIENT... yes
checking for wbcSidsToUnixIds in -lwbclient... yes
...
checking for keyutils.h... (cached) yes
checking security/pam_appl.h usability... yes
checking security/pam_appl.h presence... yes
checking for security/pam_appl.h... yes
checking for pam_start in -lpam... yes
checking for security/pam_appl.h... (cached) yes
checking for krb5_auth_con_getsendsubkey... yes
checking for krb5_principal_get_realm... no
checking for krb5_free_unparsed_name... yes
checking for krb5_auth_con_setaddrs... yes
checking for krb5_auth_con_set_req_cksumtype... yes
...
aaptel$ make
....(ok)

Without force_pam:

root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=3Dadm=
inistrator,domain=3DNUC
mount.cifs kernel mount options: ip=3D192.168.2.111,unc=3D\\adnuc.nuc.test\=
data,sec=3Dkrb5,user=3Dadministrator,domain=3DNUC
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log=
 messages (dmesg)

With force_pam:

root# ./mount.cifs -v //adnuc.nuc.test/data /x -o sec=3Dkrb5,username=3Dadm=
inistrator,domain=3DNUC,force_pam
Authenticating as user: administrator
Error in authenticating user with PAM: Authentication failure
Attempt to authenticate user with PAM unsuccessful. Still, proceeding with =
mount.

=3D> no further message but mount failed and no msg in dmesg, it didn't
   reach the mount() call

Not sure what is going on. Does the domain need to be passed to PAM?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
