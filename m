Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A87215B54C
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 05:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733377650; cv=none; b=fFKjC0VyGHsi7Nc1ykoxs7rUPCB9uwQKNO8aytj/22pCEHd3BCDruCCp8Cz4vTpnN8v6HicudmjISQNO7/DfR3VzFj2ViT0NXJHIchwVrdDhkgfTDtS/ugdNKcbi6D7jqluhg7qn4SRtoFNOzQ5kZsQcqW6BSWRL1zuywXfgH6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733377650; c=relaxed/simple;
	bh=NDHw6bH2g5erRjHOhQiWQ/9G8dl1uPpxBetM4DqaNC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBVAeKrzCaPqzig6RUFBKWCyeorJG/OQcIjas/rrVP7qKpibUv9yZKOfsLWrSk+TTc5vTpPtT9Mh6Rnsi/IKEDjCbhc/4Q/01Ynq9+F2Rv0tgsZQxawwVyLJATLgAPx1ritGH3zMzFW9s7Jr6cTFttedDafzviYmw88ieEFB/as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fK7UYKWl; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fK7UYKWl"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ffa49f623cso5346991fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Dec 2024 21:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733377647; x=1733982447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vdb7VQqaMpTMBQf/YCVjl7QvZ+2/Nnvy9YvA0GTw8Ls=;
        b=fK7UYKWlUB9T0SIxvuxgOS2MLFlLdhRhv/xyZbcTRFd8L+TqA4/cnVZ933S+AP3tbq
         L1TI6UpYUJO5AffsJO+eJRzOWDHLYpXWKJ6Pi6WghDn5uwmcuZ92EoNSmlJQdbHo19P7
         /U9WRg96m/JTi0G3s5aiiEd/QmFQ5j2rY436zN0ON6PKKXVdmYcsIpU7O1Co5G4kGMuw
         E1qTRHAbulQPaF+ES+ZA0CwvwbnMKRhIBuNxdYFEkZOAPqerOs5t+GUj1B5KTPxVowFG
         SWdoI+ou8qlt5pO2yxIywhQ/Xj/CDnlTgU1Q6r7AnJBZWtjZfbFH32T8rnTWqhIhXTyi
         CKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733377647; x=1733982447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vdb7VQqaMpTMBQf/YCVjl7QvZ+2/Nnvy9YvA0GTw8Ls=;
        b=gQ3zWukEKHVYVenvD7e120Ltgz2kdKTwvbeFtkxxCbA7LxfDgKDAPCDizhfBt8Fqus
         5jf1M0pbSp93BwrKHDQ6j7nel4fi4yvTzONsPtWGJpuOLY4EMGFjxg5YUtVr1c2qapY3
         4ue+CTSInSkONhGL7pu9Qsv41f9UlrpFjoLinpt4uSDW9DDRuQnR7wMqhAV0y6E4TCzt
         YDqMDjdwNhELVrO0ET1bWj3484Nn9EN2q6UF2+w0d2jTd5YD4ebzok26MbuhhSMer4jM
         h32/dvxW+m5Eje38nPJEUh+OLd0CsPpqeTWJs5J7ulZIv5pPMokYH1/N5oAX8V923Id6
         GzCQ==
X-Gm-Message-State: AOJu0Ywo2W3Zz0aE9teAGhcAlwmVQiIvcGujpXYFw+XLWMWD8q642+eW
	n8jB+AZ+5G5djR6cjHcA/ORM7Q8t3qZiRFz2rzYuQyumHgNSQbZmRZgOGBjNMNT9IZnBuoMeuEC
	M51UwubNkumW6jZuUKr0T2/EUUtc=
X-Gm-Gg: ASbGncs//16U7wSGdRDYmJ5bmMkcblsJkc//ZME1qBrUEVJFNVycqEUtSb2KBJDiOrk
	03FJMgQ7FN59cPYDqdDipEmxInC6E6SsiPsesAB1XGlwAc0QH6Over4VmbfKCQtb2TA==
X-Google-Smtp-Source: AGHT+IFW83r2bCvrl0WE5ixCCA6NYJtCbtxdvX6+6xtMuPNytSqZC4y/EIzCkdVD6/AesHufrhVYKSfdiUR77RCGwYs=
X-Received: by 2002:a05:6512:e96:b0:53e:18b1:ba10 with SMTP id
 2adb3069b0e04-53e18b1bafemr4153665e87.43.1733377646491; Wed, 04 Dec 2024
 21:47:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241126172744.25894-1-bharathsm.hsk@gmail.com>
In-Reply-To: <20241126172744.25894-1-bharathsm.hsk@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 4 Dec 2024 23:47:15 -0600
Message-ID: <CAH2r5muS=R-H6w4Q969RxMPZc=MQd1W8HVNdZ1_A=HjFcjAOxA@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: Skip TGT check if valid service ticket is
 already available
To: bharathsm.hsk@gmail.com
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, metze@samba.org, 
	jlayton@samba.org, pshilovsky@samba.org, pc@manguebit.com, 
	dhowells@redhat.com, sprasad@microsoft.com, rbudhiraja@microsoft.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have tentatively merged this and the two from Meetakshi (for
password/password2 handling) and the one from Ritvik (for namespace
handling) to smb3-utils for-next branch.   Let me know if any
objections, or problems found testing.   Current four next has five
changesets post cifs-utils version 7.1

968311d (HEAD -> for-next, origin/for-next) CIFS.upcall to accomodate
new namespace mount opt
a80dac4 cifs-utils: Skip TGT check if valid service ticket is already avail=
able
777ac65 use enums to check password or password2 in set_password,
get_password_from_file and minor documentation additions
82db1d6 cifs-utils: support and document password2 mount option
55dde41 smbinfo: add bash completion support for filestreaminfo, keys,
gettconinfo

On Tue, Nov 26, 2024 at 11:28=E2=80=AFAM <bharathsm.hsk@gmail.com> wrote:
>
> From: Bharath SM <bharathsm@microsoft.com>
>
> When handling upcalls from the kernel for SMB session setup requests usin=
g
> Kerberos authentication, if the credential cache already contains a valid
> service ticket, it can be used directly without checking for the TGT agai=
n.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  cifs.upcall.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 58 insertions(+), 6 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index ff6f2bd..4ad0c8e 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -552,11 +552,6 @@ get_existing_cc(const char *env_cachename)
>                 syslog(LOG_DEBUG, "%s: default ccache is %s\n", __func__,=
 cachename);
>                 krb5_free_string(context, cachename);
>         }
> -
> -       if (!get_tgt_time(cc)) {
> -               krb5_cc_close(context, cc);
> -               cc =3D NULL;
> -       }
>         return cc;
>  }
>
> @@ -638,6 +633,49 @@ icfk_cleanup:
>
>  #define CIFS_SERVICE_NAME "cifs"
>
> +static krb5_error_code check_service_ticket_exists(krb5_ccache ccache,
> +               const char *hostname) {
> +
> +       krb5_error_code rc;
> +       krb5_creds mcreds, out_creds;
> +
> +       memset(&mcreds, 0, sizeof(mcreds));
> +
> +       rc =3D krb5_cc_get_principal(context, ccache, &mcreds.client);
> +       if (rc) {
> +               syslog(LOG_DEBUG, "%s: unable to get client principal fro=
m cache: %s",
> +                                       __func__, krb5_get_error_message(=
context, rc));
> +               return rc;
> +       }
> +
> +       rc =3D krb5_sname_to_principal(context, hostname, CIFS_SERVICE_NA=
ME,
> +                       KRB5_NT_UNKNOWN, &mcreds.server);
> +       if (rc) {
> +               syslog(LOG_DEBUG, "%s: unable to convert service name (%s=
) to principal: %s",
> +                                       __func__, hostname, krb5_get_erro=
r_message(context, rc));
> +               krb5_free_principal(context, mcreds.client);
> +               return rc;
> +       }
> +
> +       rc =3D krb5_timeofday(context, &mcreds.times.endtime);
> +       if (rc) {
> +               syslog(LOG_DEBUG, "%s: unable to get time: %s",
> +                       __func__, krb5_get_error_message(context, rc));
> +               goto out_free_principal;
> +       }
> +
> +       rc =3D krb5_cc_retrieve_cred(context, ccache, KRB5_TC_MATCH_TIMES=
, &mcreds, &out_creds);
> +
> +       if (!rc)
> +               krb5_free_cred_contents(context, &out_creds);
> +
> +out_free_principal:
> +       krb5_free_principal(context, mcreds.server);
> +       krb5_free_principal(context, mcreds.client);
> +
> +       return rc;
> +}
> +
>  static int
>  cifs_krb5_get_req(const char *host, krb5_ccache ccache,
>                   DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
> @@ -1516,12 +1554,26 @@ int main(const int argc, char *const argv[])
>                 goto out;
>         }
>
> +       host =3D arg->hostname;
>         ccache =3D get_existing_cc(env_cachename);
> +       if (ccache !=3D NULL) {
> +               rc =3D check_service_ticket_exists(ccache, host);
> +               if(rc =3D=3D 0) {
> +                        syslog(LOG_DEBUG, "%s: valid service ticket exis=
ts in credential cache",
> +                                        __func__);
> +               } else {
> +                        if (!get_tgt_time(ccache)) {
> +                               syslog(LOG_DEBUG, "%s: valid TGT is not p=
resent in credential cache",
> +                                               __func__);
> +                               krb5_cc_close(context, ccache);
> +                               ccache =3D NULL;
> +                       }
> +               }
> +       }
>         /* Couldn't find credcache? Try to use keytab */
>         if (ccache =3D=3D NULL && arg->username[0] !=3D '\0')
>                 ccache =3D init_cc_from_keytab(keytab_name, arg->username=
);
>
> -       host =3D arg->hostname;
>
>         // do mech specific authorization
>         switch (arg->sec) {
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
