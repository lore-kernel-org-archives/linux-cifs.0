Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FA2211C
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 06:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731997842; cv=none; b=kIurXEoqh45qpOPsI+ma0QTd50xbKMeoC8wpTthQOIWAShF3L4DMJ6r6gX0B7Ck+mODl6fSSPdLn9+B9iN8VOHJvISyUr9om5bSOAD2iDTl/HDGzrr0xqOPig0+DUr8oovDbBD1VF8nKMxoHSx9/oIeJq0ykMfRC4dl9rnShMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731997842; c=relaxed/simple;
	bh=HdLmHsAmpVarHYaJuHIQtvlDNbcCepMTgTC8mxNmM6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Swx0kxuD1M+clavzpCwrjyhf5CJxKyOLP74xqJBQBcVrrXexj7WdVSN/pTv7+qFSH43+NRv9Jebng12AjSMBXSch8kzbapW0oJboFxczIlWp56gMxKWANN5pQJ4rDKdJrKrD2f3v18qSQ4uag0OFb5w5KklVYwTqDvtmJFo8IcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejPgsiPA; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejPgsiPA"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e387ad7abdaso3162381276.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 22:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731997839; x=1732602639; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObLXorq6qvVoH8vjpIOPBL6xOAqGQLdirUU/onSOWEM=;
        b=ejPgsiPAiA5p8eaaaSJgZ6JPrEiJbEHFePn+NrcsdTpqXrbgxtRWQYHElRbJNckgIY
         1t+m64N5q95/DMuIccDq/mild+Akrsw9lgMQolmnjcsPqZTQevT+s1voriicV1o+naEu
         dr7Lhx8vTsmho847oiGP4tLLjm20dhBCFUWeawyMkTaPVqzgf8O9gi+RGZCiAOPHkArF
         xAu72o8Q+i9lt/JGIVdsUa46xY2aNQtmXPPXty9CIlCc0rUM0nCKoYIFLioFbA/wapp/
         uD//t5PPSPVMvTyq0PE+oOhGtjLff8iukZFC+COEbVOhMXZANOsdYnlh0l0R46Z7Qhfi
         mRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731997839; x=1732602639;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ObLXorq6qvVoH8vjpIOPBL6xOAqGQLdirUU/onSOWEM=;
        b=p7fb0K06u+0ig6mIg0ifmMiDdG5tfZrqNw0CuqjTaWgPN5dT7B2NtaTCf5raiuYp2E
         Q5/cMTWBVaVBYKdchdfFQc/sE2nYtJUh4Jsc7c7u2SPttB6uSAyna1xTYyEbSoi1P6+/
         moP85J4LpMgoc0KP2nh7pavXoUYi7aN6pz2gilQq3Hl/ufpUpNdkiscJd1YG9BBirx40
         6WmJxUyizy1aIQrfPDg66o4wPrI/WpFr8DCHHPWXwNvp1FbaxZQEhTfkinLbz2uknK0F
         r+1cAopAfnKYSsBIxcA6iOJ5Wtmc9j4b1eJFKV6cFMsK+Jv6CekrKG7MrRVUoSTkAoDj
         yM5A==
X-Forwarded-Encrypted: i=1; AJvYcCWhL9Sa7J4UMwiiYM/l7l4wn6+zjYtTTLDI4nm2XtefFk28qcgoBMxjpET79CEugbR4bOqFofB0qsxi@vger.kernel.org
X-Gm-Message-State: AOJu0YxEoGkOptrRB14cfeOej5S8W5RgHIdbFlVfdS8K9ftW4aOY7/Bw
	IeAuW1QQKfst0G/R/5iDUveY9z+x9z5Eqd/xFKQqISnXLRMqVI6DkwstENImHoBcwZK3LNYPQE3
	HaxZKpUtSllxSpvh8DFteFODhIkM=
X-Google-Smtp-Source: AGHT+IGayeSCJ8WeRLA+WtCZBgEJIgWGpwecnzV7PoNQVz4jkQtrg2YV2tlRYxgY62fiQqZkAgedZiGP6zCnZ9F7/iM=
X-Received: by 2002:a05:6902:11c4:b0:e38:8263:7990 with SMTP id
 3f1490d57ef6-e3882637b7cmr9601892276.48.1731997839456; Mon, 18 Nov 2024
 22:30:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119060758.273090-1-budhirajaritviksmb@gmail.com>
In-Reply-To: <20241119060758.273090-1-budhirajaritviksmb@gmail.com>
From: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Date: Mon, 18 Nov 2024 22:30:28 -0800
Message-ID: <CA+EPQ66Egf-GEQVssORPgy41ZCUJCzWi1W2ZbexeVV2ZEXG-Qg@mail.gmail.com>
Subject: Re: [PATCH] CIFS.upcall to accomodate new namespace mount opt
To: pc@manguebit.com, dhowells@redhat.com, jlayton@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	nspmangalore@gmail.com, bharathsm.hsk@gmail.com, lsahlber@redhat.com, 
	ronniesahlberg@gmail.com
Content-Type: multipart/mixed; boundary="000000000000f943e106273e2b0f"

--000000000000f943e106273e2b0f
Content-Type: multipart/alternative; boundary="000000000000f943df06273e2b0d"

--000000000000f943df06273e2b0d
Content-Type: text/plain; charset="UTF-8"

Attaching the previously sent patch which introduces the upcall target mount
opt for the kernel. The current patch is dependent on the attached patch
below.


On Mon, 18 Nov 2024 at 22:08, <budhirajaritviksmb@gmail.com> wrote:

> From: Ritvik Budhiraja <rbudhiraja@microsoft.com>
>
> NOTE: This patch is dependent on one of the previously sent patches:
> [PATCH] CIFS: New mount option for cifs.upcall namespace resolution
> which introduces a new mount option called upcall_target, to
> customise the upcall behaviour.
>
> Building upon the above patch, the following patch adds functionality
> to handle upcall_target as a mount option in cifs.upcall. It can have 2
> values -
> mount, app.
> Having this new mount option allows the mount command to specify where the
> upcall should happen: 'mount' for resolving the upcall to the host
> namespace, and 'app' for resolving the upcall to the ns of the calling
> thread. This will enable both the scenarios where the Kerberos credentials
> can be found on the application namespace or the host namespace to which
> just the mount operation is "delegated".
> This aids use cases like Kubernetes where the mount
> happens on behalf of the application in another container altogether.
>
> Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
> ---
>  cifs.upcall.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index ff6f2bd..a790aca 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -954,6 +954,13 @@ struct decoded_args {
>  #define MAX_USERNAME_SIZE 256
>         char username[MAX_USERNAME_SIZE + 1];
>
> +#define MAX_UPCALL_STRING_LEN 6 /* "mount\0" */
> +       enum upcall_target_enum {
> +               UPTARGET_UNSPECIFIED, /* not specified, defaults to app */
> +               UPTARGET_MOUNT, /* upcall to the mount namespace */
> +               UPTARGET_APP, /* upcall to the application namespace which
> did the mount */
> +       } upcall_target;
> +
>         uid_t uid;
>         uid_t creduid;
>         pid_t pid;
> @@ -970,6 +977,7 @@ struct decoded_args {
>  #define DKD_HAVE_PID           0x20
>  #define DKD_HAVE_CREDUID       0x40
>  #define DKD_HAVE_USERNAME      0x80
> +#define DKD_HAVE_UPCALL_TARGET 0x100
>  #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
>         int have;
>  };
> @@ -980,6 +988,7 @@ __decode_key_description(const char *desc, struct
> decoded_args *arg)
>         size_t len;
>         char *pos;
>         const char *tkn = desc;
> +       arg->upcall_target = UPTARGET_UNSPECIFIED;
>
>         do {
>                 pos = index(tkn, ';');
> @@ -1078,6 +1087,31 @@ __decode_key_description(const char *desc, struct
> decoded_args *arg)
>                         }
>                         arg->have |= DKD_HAVE_VERSION;
>                         syslog(LOG_DEBUG, "ver=%d", arg->ver);
> +               } else if (strncmp(tkn, "upcall_target=", 14) == 0) {
> +                       if (pos == NULL)
> +                               len = strlen(tkn);
> +                       else
> +                               len = pos - tkn;
> +
> +                       len -= 14;
> +                       if (len > MAX_UPCALL_STRING_LEN) {
> +                               syslog(LOG_ERR, "upcall_target= value too
> long for buffer");
> +                               return 1;
> +                       }
> +                       if (strncmp(tkn + 14, "mount", 5) == 0) {
> +                               arg->upcall_target = UPTARGET_MOUNT;
> +                               syslog(LOG_DEBUG, "upcall_target=mount");
> +                       } else if (strncmp(tkn + 14, "app", 3) == 0) {
> +                               arg->upcall_target = UPTARGET_APP;
> +                               syslog(LOG_DEBUG, "upcall_target=app");
> +                       } else {
> +                               // Should never happen
> +                               syslog(LOG_ERR, "Invalid upcall_target
> value: %s, defaulting to app",
> +                                      tkn + 14);
> +                               arg->upcall_target = UPTARGET_APP;
> +                               syslog(LOG_DEBUG, "upcall_target=app");
> +                       }
> +                       arg->have |= DKD_HAVE_UPCALL_TARGET;
>                 }
>                 if (pos == NULL)
>                         break;
> @@ -1441,15 +1475,20 @@ int main(const int argc, char *const argv[])
>          * acceptably in containers, because we'll be looking at the
> correct
>          * filesystem and have the correct network configuration.
>          */
> -       rc = switch_to_process_ns(arg->pid);
> -       if (rc == -1) {
> -               syslog(LOG_ERR, "unable to switch to process namespace:
> %s", strerror(errno));
> -               rc = 1;
> -               goto out;
> +       if (arg->upcall_target == UPTARGET_APP || arg->upcall_target ==
> UPTARGET_UNSPECIFIED) {
> +               syslog(LOG_INFO, "upcall_target=app, switching namespaces
> to application thread");
> +               rc = switch_to_process_ns(arg->pid);
> +               if (rc == -1) {
> +                       syslog(LOG_ERR, "unable to switch to process
> namespace: %s", strerror(errno));
> +                       rc = 1;
> +                       goto out;
> +               }
> +               if (trim_capabilities(env_probe))
> +                       goto out;
> +       } else {
> +               syslog(LOG_INFO, "upcall_target=mount, not switching
> namespaces to application thread");
>         }
>
> -       if (trim_capabilities(env_probe))
> -               goto out;
>
>         /*
>          * The kernel doesn't pass down the gid, so we resort here to
> scraping
> @@ -1496,7 +1535,7 @@ int main(const int argc, char *const argv[])
>          * look at the environ file.
>          */
>         env_cachename =
> -               get_cachename_from_process_env(env_probe ? arg->pid : 0);
> +               get_cachename_from_process_env((env_probe &&
> (arg->upcall_target == UPTARGET_APP)) ? arg->pid : 0);
>
>         rc = setuid(uid);
>         if (rc == -1) {
> --
> 2.43.0
>
>

--000000000000f943df06273e2b0d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+QXR0YWNoaW5nIHRoZSBwcmV2aW91c2x5IHNlbnQgcGF0Y2ggd2hpY2gg
aW50cm9kdWNlcyB0aGUgdXBjYWxsIHRhcmdldCBtb3VudDxkaXY+b3B0IGZvciB0aGUga2VybmVs
LiBUaGUgY3VycmVudCBwYXRjaCBpcyBkZXBlbmRlbnQgb24gdGhlIGF0dGFjaGVkIHBhdGNoIGJl
bG93LjwvZGl2PjxkaXY+PGJyPjwvZGl2PjwvZGl2Pjxicj48ZGl2IGNsYXNzPSJnbWFpbF9xdW90
ZSI+PGRpdiBkaXI9Imx0ciIgY2xhc3M9ImdtYWlsX2F0dHIiPk9uIE1vbiwgMTggTm92IDIwMjQg
YXQgMjI6MDgsICZsdDs8YSBocmVmPSJtYWlsdG86YnVkaGlyYWphcml0dmlrc21iQGdtYWlsLmNv
bSI+YnVkaGlyYWphcml0dmlrc21iQGdtYWlsLmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj48L2Rpdj48
YmxvY2txdW90ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MHB4IDBweCAwcHgg
MC44ZXg7Ym9yZGVyLWxlZnQ6MXB4IHNvbGlkIHJnYigyMDQsMjA0LDIwNCk7cGFkZGluZy1sZWZ0
OjFleCI+RnJvbTogUml0dmlrIEJ1ZGhpcmFqYSAmbHQ7PGEgaHJlZj0ibWFpbHRvOnJidWRoaXJh
amFAbWljcm9zb2Z0LmNvbSIgdGFyZ2V0PSJfYmxhbmsiPnJidWRoaXJhamFAbWljcm9zb2Z0LmNv
bTwvYT4mZ3Q7PGJyPg0KPGJyPg0KTk9URTogVGhpcyBwYXRjaCBpcyBkZXBlbmRlbnQgb24gb25l
IG9mIHRoZSBwcmV2aW91c2x5IHNlbnQgcGF0Y2hlczo8YnI+DQpbUEFUQ0hdIENJRlM6IE5ldyBt
b3VudCBvcHRpb24gZm9yIGNpZnMudXBjYWxsIG5hbWVzcGFjZSByZXNvbHV0aW9uPGJyPg0Kd2hp
Y2ggaW50cm9kdWNlcyBhIG5ldyBtb3VudCBvcHRpb24gY2FsbGVkIHVwY2FsbF90YXJnZXQsIHRv
PGJyPg0KY3VzdG9taXNlIHRoZSB1cGNhbGwgYmVoYXZpb3VyLjxicj4NCjxicj4NCkJ1aWxkaW5n
IHVwb24gdGhlIGFib3ZlIHBhdGNoLCB0aGUgZm9sbG93aW5nIHBhdGNoIGFkZHMgZnVuY3Rpb25h
bGl0eTxicj4NCnRvIGhhbmRsZSB1cGNhbGxfdGFyZ2V0IGFzIGEgbW91bnQgb3B0aW9uIGluIGNp
ZnMudXBjYWxsLiBJdCBjYW4gaGF2ZSAyIHZhbHVlcyAtPGJyPg0KbW91bnQsIGFwcC4gPGJyPg0K
SGF2aW5nIHRoaXMgbmV3IG1vdW50IG9wdGlvbiBhbGxvd3MgdGhlIG1vdW50IGNvbW1hbmQgdG8g
c3BlY2lmeSB3aGVyZSB0aGU8YnI+DQp1cGNhbGwgc2hvdWxkIGhhcHBlbjogJiMzOTttb3VudCYj
Mzk7IGZvciByZXNvbHZpbmcgdGhlIHVwY2FsbCB0byB0aGUgaG9zdDxicj4NCm5hbWVzcGFjZSwg
YW5kICYjMzk7YXBwJiMzOTsgZm9yIHJlc29sdmluZyB0aGUgdXBjYWxsIHRvIHRoZSBucyBvZiB0
aGUgY2FsbGluZzxicj4NCnRocmVhZC4gVGhpcyB3aWxsIGVuYWJsZSBib3RoIHRoZSBzY2VuYXJp
b3Mgd2hlcmUgdGhlIEtlcmJlcm9zIGNyZWRlbnRpYWxzPGJyPg0KY2FuIGJlIGZvdW5kIG9uIHRo
ZSBhcHBsaWNhdGlvbiBuYW1lc3BhY2Ugb3IgdGhlIGhvc3QgbmFtZXNwYWNlIHRvIHdoaWNoPGJy
Pg0KanVzdCB0aGUgbW91bnQgb3BlcmF0aW9uIGlzICZxdW90O2RlbGVnYXRlZCZxdW90Oy48YnI+
DQpUaGlzIGFpZHMgdXNlIGNhc2VzIGxpa2UgS3ViZXJuZXRlcyB3aGVyZSB0aGUgbW91bnQ8YnI+
DQpoYXBwZW5zIG9uIGJlaGFsZiBvZiB0aGUgYXBwbGljYXRpb24gaW4gYW5vdGhlciBjb250YWlu
ZXIgYWx0b2dldGhlci48YnI+DQo8YnI+DQpTaWduZWQtb2ZmLWJ5OiBSaXR2aWsgQnVkaGlyYWph
ICZsdDs8YSBocmVmPSJtYWlsdG86cmJ1ZGhpcmFqYUBtaWNyb3NvZnQuY29tIiB0YXJnZXQ9Il9i
bGFuayI+cmJ1ZGhpcmFqYUBtaWNyb3NvZnQuY29tPC9hPiZndDs8YnI+DQotLS08YnI+DQrCoGNp
ZnMudXBjYWxsLmMgfCA1NSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0tLS0tLS08YnI+DQrCoDEgZmlsZSBjaGFuZ2VkLCA0NyBpbnNlcnRpb25zKCspLCA4IGRl
bGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9jaWZzLnVwY2FsbC5jIGIvY2lmcy51
cGNhbGwuYzxicj4NCmluZGV4IGZmNmYyYmQuLmE3OTBhY2EgMTAwNjQ0PGJyPg0KLS0tIGEvY2lm
cy51cGNhbGwuYzxicj4NCisrKyBiL2NpZnMudXBjYWxsLmM8YnI+DQpAQCAtOTU0LDYgKzk1NCwx
MyBAQCBzdHJ1Y3QgZGVjb2RlZF9hcmdzIHs8YnI+DQrCoCNkZWZpbmUgTUFYX1VTRVJOQU1FX1NJ
WkUgMjU2PGJyPg0KwqAgwqAgwqAgwqAgY2hhciB1c2VybmFtZVtNQVhfVVNFUk5BTUVfU0laRSAr
IDFdOzxicj4NCjxicj4NCisjZGVmaW5lIE1BWF9VUENBTExfU1RSSU5HX0xFTiA2IC8qICZxdW90
O21vdW50XDAmcXVvdDsgKi88YnI+DQorwqAgwqAgwqAgwqBlbnVtIHVwY2FsbF90YXJnZXRfZW51
bSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgVVBUQVJHRVRfVU5TUEVDSUZJRUQsIC8q
IG5vdCBzcGVjaWZpZWQsIGRlZmF1bHRzIHRvIGFwcCAqLzxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoFVQVEFSR0VUX01PVU5ULCAvKiB1cGNhbGwgdG8gdGhlIG1vdW50IG5hbWVzcGFjZSAq
Lzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFVQVEFSR0VUX0FQUCwgLyogdXBjYWxsIHRv
IHRoZSBhcHBsaWNhdGlvbiBuYW1lc3BhY2Ugd2hpY2ggZGlkIHRoZSBtb3VudCAqLzxicj4NCivC
oCDCoCDCoCDCoH0gdXBjYWxsX3RhcmdldDs8YnI+DQorPGJyPg0KwqAgwqAgwqAgwqAgdWlkX3Qg
dWlkOzxicj4NCsKgIMKgIMKgIMKgIHVpZF90IGNyZWR1aWQ7PGJyPg0KwqAgwqAgwqAgwqAgcGlk
X3QgcGlkOzxicj4NCkBAIC05NzAsNiArOTc3LDcgQEAgc3RydWN0IGRlY29kZWRfYXJncyB7PGJy
Pg0KwqAjZGVmaW5lIERLRF9IQVZFX1BJRMKgIMKgIMKgIMKgIMKgIMKgMHgyMDxicj4NCsKgI2Rl
ZmluZSBES0RfSEFWRV9DUkVEVUlEwqAgwqAgwqAgwqAweDQwPGJyPg0KwqAjZGVmaW5lIERLRF9I
QVZFX1VTRVJOQU1FwqAgwqAgwqAgMHg4MDxicj4NCisjZGVmaW5lIERLRF9IQVZFX1VQQ0FMTF9U
QVJHRVQgMHgxMDA8YnI+DQrCoCNkZWZpbmUgREtEX01VU1RIQVZFX1NFVCAoREtEX0hBVkVfSE9T
VE5BTUV8REtEX0hBVkVfVkVSU0lPTnxES0RfSEFWRV9TRUMpPGJyPg0KwqAgwqAgwqAgwqAgaW50
IGhhdmU7PGJyPg0KwqB9Ozxicj4NCkBAIC05ODAsNiArOTg4LDcgQEAgX19kZWNvZGVfa2V5X2Rl
c2NyaXB0aW9uKGNvbnN0IGNoYXIgKmRlc2MsIHN0cnVjdCBkZWNvZGVkX2FyZ3MgKmFyZyk8YnI+
DQrCoCDCoCDCoCDCoCBzaXplX3QgbGVuOzxicj4NCsKgIMKgIMKgIMKgIGNoYXIgKnBvczs8YnI+
DQrCoCDCoCDCoCDCoCBjb25zdCBjaGFyICp0a24gPSBkZXNjOzxicj4NCivCoCDCoCDCoCDCoGFy
Zy0mZ3Q7dXBjYWxsX3RhcmdldCA9IFVQVEFSR0VUX1VOU1BFQ0lGSUVEOzxicj4NCjxicj4NCsKg
IMKgIMKgIMKgIGRvIHs8YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwb3MgPSBpbmRleCh0
a24sICYjMzk7OyYjMzk7KTs8YnI+DQpAQCAtMTA3OCw2ICsxMDg3LDMxIEBAIF9fZGVjb2RlX2tl
eV9kZXNjcmlwdGlvbihjb25zdCBjaGFyICpkZXNjLCBzdHJ1Y3QgZGVjb2RlZF9hcmdzICphcmcp
PGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGFyZy0mZ3Q7aGF2ZSB8PSBES0RfSEFWRV9WRVJT
SU9OOzxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN5c2xvZyhMT0df
REVCVUcsICZxdW90O3Zlcj0lZCZxdW90OywgYXJnLSZndDt2ZXIpOzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoH0gZWxzZSBpZiAoc3RybmNtcCh0a24sICZxdW90O3VwY2FsbF90YXJnZXQ9
JnF1b3Q7LCAxNCkgPT0gMCkgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGlmIChwb3MgPT0gTlVMTCk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBsZW4gPSBzdHJsZW4odGtuKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqBlbHNlPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgbGVuID0gcG9zIC0gdGtuOzxicj4NCis8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBsZW4gLT0gMTQ7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGxlbiAmZ3Q7IE1BWF9VUENBTExfU1RSSU5HX0xF
Tikgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHN5c2xvZyhMT0dfRVJSLCAmcXVvdDt1cGNhbGxfdGFyZ2V0PSB2YWx1ZSB0b28gbG9uZyBmb3Ig
YnVmZmVyJnF1b3Q7KTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqByZXR1cm4gMTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqB9PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHN0cm5j
bXAodGtuICsgMTQsICZxdW90O21vdW50JnF1b3Q7LCA1KSA9PSAwKSB7PGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYXJnLSZndDt1cGNhbGxfdGFy
Z2V0ID0gVVBUQVJHRVRfTU9VTlQ7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgc3lzbG9nKExPR19ERUJVRywgJnF1b3Q7dXBjYWxsX3RhcmdldD1t
b3VudCZxdW90Oyk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgfSBl
bHNlIGlmIChzdHJuY21wKHRrbiArIDE0LCAmcXVvdDthcHAmcXVvdDssIDMpID09IDApIHs8YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBhcmctJmd0
O3VwY2FsbF90YXJnZXQgPSBVUFRBUkdFVF9BUFA7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3lzbG9nKExPR19ERUJVRywgJnF1b3Q7dXBjYWxs
X3RhcmdldD1hcHAmcXVvdDspOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoH0gZWxzZSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgLy8gU2hvdWxkIG5ldmVyIGhhcHBlbjxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHN5c2xvZyhMT0dfRVJSLCAmcXVvdDtJbnZhbGlk
IHVwY2FsbF90YXJnZXQgdmFsdWU6ICVzLCBkZWZhdWx0aW5nIHRvIGFwcCZxdW90Oyw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
dGtuICsgMTQpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoGFyZy0mZ3Q7dXBjYWxsX3RhcmdldCA9IFVQVEFSR0VUX0FQUDs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzeXNsb2coTE9HX0RFQlVH
LCAmcXVvdDt1cGNhbGxfdGFyZ2V0PWFwcCZxdW90Oyk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgfTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGFyZy0mZ3Q7aGF2ZSB8PSBES0RfSEFWRV9VUENBTExfVEFSR0VUOzxicj4NCsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIH08YnI+DQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAocG9zID09
IE5VTEwpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7PGJy
Pg0KQEAgLTE0NDEsMTUgKzE0NzUsMjAgQEAgaW50IG1haW4oY29uc3QgaW50IGFyZ2MsIGNoYXIg
KmNvbnN0IGFyZ3ZbXSk8YnI+DQrCoCDCoCDCoCDCoCDCoCogYWNjZXB0YWJseSBpbiBjb250YWlu
ZXJzLCBiZWNhdXNlIHdlJiMzOTtsbCBiZSBsb29raW5nIGF0IHRoZSBjb3JyZWN0PGJyPg0KwqAg
wqAgwqAgwqAgwqAqIGZpbGVzeXN0ZW0gYW5kIGhhdmUgdGhlIGNvcnJlY3QgbmV0d29yayBjb25m
aWd1cmF0aW9uLjxicj4NCsKgIMKgIMKgIMKgIMKgKi88YnI+DQotwqAgwqAgwqAgwqByYyA9IHN3
aXRjaF90b19wcm9jZXNzX25zKGFyZy0mZ3Q7cGlkKTs8YnI+DQotwqAgwqAgwqAgwqBpZiAocmMg
PT0gLTEpIHs8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzeXNsb2coTE9HX0VSUiwgJnF1
b3Q7dW5hYmxlIHRvIHN3aXRjaCB0byBwcm9jZXNzIG5hbWVzcGFjZTogJXMmcXVvdDssIHN0cmVy
cm9yKGVycm5vKSk7PGJyPg0KLcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmMgPSAxOzxicj4NCi3C
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdvdG8gb3V0Ozxicj4NCivCoCDCoCDCoCDCoGlmIChhcmct
Jmd0O3VwY2FsbF90YXJnZXQgPT0gVVBUQVJHRVRfQVBQIHx8IGFyZy0mZ3Q7dXBjYWxsX3Rhcmdl
dCA9PSBVUFRBUkdFVF9VTlNQRUNJRklFRCkgezxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oHN5c2xvZyhMT0dfSU5GTywgJnF1b3Q7dXBjYWxsX3RhcmdldD1hcHAsIHN3aXRjaGluZyBuYW1l
c3BhY2VzIHRvIGFwcGxpY2F0aW9uIHRocmVhZCZxdW90Oyk7PGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgcmMgPSBzd2l0Y2hfdG9fcHJvY2Vzc19ucyhhcmctJmd0O3BpZCk7PGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHJjID09IC0xKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgc3lzbG9nKExPR19FUlIsICZxdW90O3VuYWJsZSB0byBzd2l0
Y2ggdG8gcHJvY2VzcyBuYW1lc3BhY2U6ICVzJnF1b3Q7LCBzdHJlcnJvcihlcnJubykpOzxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJjID0gMTs8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqB9PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHRyaW1fY2FwYWJp
bGl0aWVzKGVudl9wcm9iZSkpPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgZ290byBvdXQ7PGJyPg0KK8KgIMKgIMKgIMKgfSBlbHNlIHs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqBzeXNsb2coTE9HX0lORk8sICZxdW90O3VwY2FsbF90YXJnZXQ9bW91bnQsIG5v
dCBzd2l0Y2hpbmcgbmFtZXNwYWNlcyB0byBhcHBsaWNhdGlvbiB0aHJlYWQmcXVvdDspOzxicj4N
CsKgIMKgIMKgIMKgIH08YnI+DQo8YnI+DQotwqAgwqAgwqAgwqBpZiAodHJpbV9jYXBhYmlsaXRp
ZXMoZW52X3Byb2JlKSk8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBnb3RvIG91dDs8YnI+
DQo8YnI+DQrCoCDCoCDCoCDCoCAvKjxicj4NCsKgIMKgIMKgIMKgIMKgKiBUaGUga2VybmVsIGRv
ZXNuJiMzOTt0IHBhc3MgZG93biB0aGUgZ2lkLCBzbyB3ZSByZXNvcnQgaGVyZSB0byBzY3JhcGlu
Zzxicj4NCkBAIC0xNDk2LDcgKzE1MzUsNyBAQCBpbnQgbWFpbihjb25zdCBpbnQgYXJnYywgY2hh
ciAqY29uc3QgYXJndltdKTxicj4NCsKgIMKgIMKgIMKgIMKgKiBsb29rIGF0IHRoZSBlbnZpcm9u
IGZpbGUuPGJyPg0KwqAgwqAgwqAgwqAgwqAqLzxicj4NCsKgIMKgIMKgIMKgIGVudl9jYWNoZW5h
bWUgPTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdldF9jYWNoZW5hbWVfZnJvbV9wcm9j
ZXNzX2VudihlbnZfcHJvYmUgPyBhcmctJmd0O3BpZCA6IDApOzxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoGdldF9jYWNoZW5hbWVfZnJvbV9wcm9jZXNzX2VudigoZW52X3Byb2JlICZhbXA7
JmFtcDsgKGFyZy0mZ3Q7dXBjYWxsX3RhcmdldCA9PSBVUFRBUkdFVF9BUFApKSA/IGFyZy0mZ3Q7
cGlkIDogMCk7PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgcmMgPSBzZXR1aWQodWlkKTs8YnI+DQrC
oCDCoCDCoCDCoCBpZiAocmMgPT0gLTEpIHs8YnI+DQotLSA8YnI+DQoyLjQzLjA8YnI+DQo8YnI+
DQo8L2Jsb2NrcXVvdGU+PC9kaXY+DQo=
--000000000000f943df06273e2b0d--
--000000000000f943e106273e2b0f
Content-Type: application/octet-stream; name="upcall_target_patch.patch"
Content-Disposition: attachment; filename="upcall_target_patch.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3o2s4zn0>
X-Attachment-Id: f_m3o2s4zn0

RnJvbSA4MWY3MjdhN2M1NjNiMGM0ODIyNDE3MTRhYTZjMGRhN2M2NmRkNDRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUml0dmlrIEJ1ZGhpcmFqYSA8cmJ1ZGhpcmFqYUBtaWNyb3Nv
ZnQuY29tPg0KRGF0ZTogTW9uLCAxMSBOb3YgMjAyNCAxMTozMjoyMyArMDAwMA0KU3ViamVjdDog
W1BBVENIXSBDSUZTOiBOZXcgbW91bnQgb3B0aW9uIGZvciBjaWZzLnVwY2FsbCBuYW1lc3BhY2Ug
cmVzb2x1dGlvbg0KDQpJbiB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiwgdGhlIFNNQiBmaWxl
c3lzdGVtIG9uIGEgbW91bnQgcG9pbnQgY2FuIA0KdHJpZ2dlciB1cGNhbGxzIGZyb20gdGhlIGtl
cm5lbCB0byB0aGUgdXNlcnNwYWNlIHRvIGVuYWJsZSBjZXJ0YWluIA0KZnVuY3Rpb25hbGl0aWVz
IGxpa2Ugc3BuZWdvLCBkbnNfcmVzb2x1dGlvbiwgYW1vbmdzdCBvdGhlcnMuIFRoZXNlIHVwY2Fs
bHMgDQp1c3VhbGx5IGVpdGhlciBoYXBwZW4gaW4gdGhlIGNvbnRleHQgb2YgdGhlIG1vdW50IG9y
IGluIHRoZSBjb250ZXh0IG9mIGFuIA0KYXBwbGljYXRpb24vdXNlci4gVGhlIHVwY2FsbCBoYW5k
bGVyIGZvciBjaWZzLCBjaWZzLnVwY2FsbCBhbHJlYWR5IGhhcyANCmV4aXN0aW5nIGNvZGUgd2hp
Y2ggc3dpdGNoZXMgdGhlIG5hbWVzcGFjZXMgdG8gdGhlIGNhbGxlcidzIG5hbWVzcGFjZSANCmJl
Zm9yZSBoYW5kbGluZyB0aGUgdXBjYWxsLiBUaGlzIGJlaGF2aW91ciBpcyBleHBlY3RlZCBmb3Ig
c2NlbmFyaW9zIGxpa2UgDQptdWx0aXVzZXIgbW91bnRzLCBidXQgbWlnaHQgbm90IGNvdmVyIGFs
bCBzaW5nbGUgdXNlciBzY2VuYXJpbyB3aXRoIA0Kc2VydmljZXMgc3VjaCBhcyBLdWJlcm5ldGVz
LCB3aGVyZSB0aGUgbW91bnQgY2FuIGhhcHBlbiBmcm9tIGRpZmZlcmVudCANCmxvY2F0aW9ucyBz
dWNoIGFzIG9uIHRoZSBob3N0LCBmcm9tIGFuIGFwcCBjb250YWluZXIsIG9yIGEgZHJpdmVyIHBv
ZCANCndoaWNoIGRvZXMgdGhlIG1vdW50IG9uIGJlaGFsZiBvZiBhIGRpZmZlcmVudCBwb2QuIA0K
DQpUaGlzIHBhdGNoIGludHJvZHVjZXMgYSBuZXcgbW91bnQgb3B0aW9uIGNhbGxlZCB1cGNhbGxf
dGFyZ2V0LCB0byANCmN1c3RvbWlzZSB0aGUgdXBjYWxsIGJlaGF2aW91ci4gdXBjYWxsX3Rhcmdl
dCBjYW4gdGFrZSAnbW91bnQnIGFuZCAnYXBwJyANCmFzIHBvc3NpYmxlIHZhbHVlcy4gVGhpcyBh
aWRzIHVzZSBjYXNlcyBsaWtlIEt1YmVybmV0ZXMgd2hlcmUgdGhlIG1vdW50IA0KaGFwcGVucyBv
biBiZWhhbGYgb2YgdGhlIGFwcGxpY2F0aW9uIGluIGFub3RoZXIgY29udGFpbmVyIGFsdG9nZXRo
ZXIuIA0KSGF2aW5nIHRoaXMgbmV3IG1vdW50IG9wdGlvbiBhbGxvd3MgdGhlIG1vdW50IGNvbW1h
bmQgdG8gc3BlY2lmeSB3aGVyZSB0aGUgDQp1cGNhbGwgc2hvdWxkIGhhcHBlbjogJ21vdW50JyBm
b3IgcmVzb2x2aW5nIHRoZSB1cGNhbGwgdG8gdGhlIGhvc3QgDQpuYW1lc3BhY2UsIGFuZCAnYXBw
JyBmb3IgcmVzb2x2aW5nIHRoZSB1cGNhbGwgdG8gdGhlIG5zIG9mIHRoZSBjYWxsaW5nIA0KdGhy
ZWFkLiBUaGlzIHdpbGwgZW5hYmxlIGJvdGggdGhlIHNjZW5hcmlvcyB3aGVyZSB0aGUgS2VyYmVy
b3MgY3JlZGVudGlhbHMgDQpjYW4gYmUgZm91bmQgb24gdGhlIGFwcGxpY2F0aW9uIG5hbWVzcGFj
ZSBvciB0aGUgaG9zdCBuYW1lc3BhY2UgdG8gd2hpY2ggDQpqdXN0IHRoZSBtb3VudCBvcGVyYXRp
b24gaXMgImRlbGVnYXRlZCIuIA0KDQpSZXZpZXdlZC1ieTogU2h5YW0gUHJhc2FkIDxzaHlhbS5w
cmFzYWRAbWljcm9zb2Z0LmNvbT4NClJldmlld2VkLWJ5OiBCaGFyYXRoIFMgTSA8YmhhcmF0aHNt
QG1pY3Jvc29mdC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBSaXR2aWsgQnVkaGlyYWphIDxyYnVkaGly
YWphQG1pY3Jvc29mdC5jb20+DQotLS0NCiBmcy9zbWIvY2xpZW50L2NpZnNfc3BuZWdvLmMgfCAx
NiArKysrKysrKysrKysrKysNCiBmcy9zbWIvY2xpZW50L2NpZnNmcy5jICAgICAgfCAyNSArKysr
KysrKysrKysrKysrKysrKysrKysNCiBmcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggICAgfCAgNyAr
KysrKysrDQogZnMvc21iL2NsaWVudC9jb25uZWN0LmMgICAgIHwgMjAgKysrKysrKysrKysrKysr
KysrKw0KIGZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jICB8IDM5ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCiBmcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuaCAgfCAxMCAr
KysrKysrKysrDQogNiBmaWxlcyBjaGFuZ2VkLCAxMTcgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0t
Z2l0IGEvZnMvc21iL2NsaWVudC9jaWZzX3NwbmVnby5jIGIvZnMvc21iL2NsaWVudC9jaWZzX3Nw
bmVnby5jDQppbmRleCBhZjc4NDllNTkuLjI4ZjU2OGI1ZiAxMDA2NDQNCi0tLSBhL2ZzL3NtYi9j
bGllbnQvY2lmc19zcG5lZ28uYw0KKysrIGIvZnMvc21iL2NsaWVudC9jaWZzX3NwbmVnby5jDQpA
QCAtODIsNiArODIsOSBAQCBzdHJ1Y3Qga2V5X3R5cGUgY2lmc19zcG5lZ29fa2V5X3R5cGUgPSB7
DQogLyogc3RybGVuIG9mICI7cGlkPTB4IiAqLw0KICNkZWZpbmUgUElEX0tFWV9MRU4JCTcNCiAN
CisvKiBzdHJsZW4gb2YgIjt1cGNhbGxfdGFyZ2V0PSIgKi8NCisjZGVmaW5lIFVQQ0FMTF9UQVJH
RVRfS0VZX0xFTgkxNQ0KKw0KIC8qIGdldCBhIGtleSBzdHJ1Y3Qgd2l0aCBhIFNQTkVHTyBzZWN1
cml0eSBibG9iLCBzdWl0YWJsZSBmb3Igc2Vzc2lvbiBzZXR1cCAqLw0KIHN0cnVjdCBrZXkgKg0K
IGNpZnNfZ2V0X3NwbmVnb19rZXkoc3RydWN0IGNpZnNfc2VzICpzZXNJbmZvLA0KQEAgLTEwOCw2
ICsxMTEsMTEgQEAgY2lmc19nZXRfc3BuZWdvX2tleShzdHJ1Y3QgY2lmc19zZXMgKnNlc0luZm8s
DQogCWlmIChzZXNJbmZvLT51c2VyX25hbWUpDQogCQlkZXNjX2xlbiArPSBVU0VSX0tFWV9MRU4g
KyBzdHJsZW4oc2VzSW5mby0+dXNlcl9uYW1lKTsNCiANCisJaWYgKHNlc0luZm8tPnVwY2FsbF90
YXJnZXQgPT0gVVBUQVJHRVRfTU9VTlQpDQorCQlkZXNjX2xlbiArPSBVUENBTExfVEFSR0VUX0tF
WV9MRU4gKyA1OyAvLyBzdHJsZW4oIm1vdW50IikNCisJZWxzZQ0KKwkJZGVzY19sZW4gKz0gVVBD
QUxMX1RBUkdFVF9LRVlfTEVOICsgMzsgLy8gc3RybGVuKCJhcHAiKQ0KKw0KIAlzcG5lZ29fa2V5
ID0gRVJSX1BUUigtRU5PTUVNKTsNCiAJZGVzY3JpcHRpb24gPSBremFsbG9jKGRlc2NfbGVuLCBH
RlBfS0VSTkVMKTsNCiAJaWYgKGRlc2NyaXB0aW9uID09IE5VTEwpDQpAQCAtMTU2LDYgKzE2NCwx
NCBAQCBjaWZzX2dldF9zcG5lZ29fa2V5KHN0cnVjdCBjaWZzX3NlcyAqc2VzSW5mbywNCiAJZHAg
PSBkZXNjcmlwdGlvbiArIHN0cmxlbihkZXNjcmlwdGlvbik7DQogCXNwcmludGYoZHAsICI7cGlk
PTB4JXgiLCBjdXJyZW50LT5waWQpOw0KIA0KKwlpZiAoc2VzSW5mby0+dXBjYWxsX3RhcmdldCA9
PSBVUFRBUkdFVF9NT1VOVCkgew0KKwkJZHAgPSBkZXNjcmlwdGlvbiArIHN0cmxlbihkZXNjcmlw
dGlvbik7DQorCQlzcHJpbnRmKGRwLCAiO3VwY2FsbF90YXJnZXQ9bW91bnQiKTsNCisJfSBlbHNl
IHsNCisJCWRwID0gZGVzY3JpcHRpb24gKyBzdHJsZW4oZGVzY3JpcHRpb24pOw0KKwkJc3ByaW50
ZihkcCwgIjt1cGNhbGxfdGFyZ2V0PWFwcCIpOw0KKwl9DQorDQogCWNpZnNfZGJnKEZZSSwgImtl
eSBkZXNjcmlwdGlvbiA9ICVzXG4iLCBkZXNjcmlwdGlvbik7DQogCXNhdmVkX2NyZWQgPSBvdmVy
cmlkZV9jcmVkcyhzcG5lZ29fY3JlZCk7DQogCXNwbmVnb19rZXkgPSByZXF1ZXN0X2tleSgmY2lm
c19zcG5lZ29fa2V5X3R5cGUsIGRlc2NyaXB0aW9uLCAiIik7DQpkaWZmIC0tZ2l0IGEvZnMvc21i
L2NsaWVudC9jaWZzZnMuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMNCmluZGV4IDJhMjUyM2M5
My4uYWM4OWJkMTk5IDEwMDY0NA0KLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYw0KKysrIGIv
ZnMvc21iL2NsaWVudC9jaWZzZnMuYw0KQEAgLTUzNSw2ICs1MzUsMzAgQEAgc3RhdGljIGludCBj
aWZzX3Nob3dfZGV2bmFtZShzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHN0cnVjdCBkZW50cnkgKnJvb3Qp
DQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdm9pZA0KK2NpZnNfc2hvd191cGNhbGxfdGFy
Z2V0KHN0cnVjdCBzZXFfZmlsZSAqcywgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYikNCit7
DQorCWlmIChjaWZzX3NiLT5jdHgtPnVwY2FsbF90YXJnZXQgPT0gVVBUQVJHRVRfVU5TUEVDSUZJ
RUQpIHsNCisJCXNlcV9wdXRzKHMsICIsdXBjYWxsX3RhcmdldD1hcHAiKTsNCisJCXJldHVybjsN
CisJfQ0KKw0KKwlzZXFfcHV0cyhzLCAiLHVwY2FsbF90YXJnZXQ9Iik7DQorDQorCXN3aXRjaCAo
Y2lmc19zYi0+Y3R4LT51cGNhbGxfdGFyZ2V0KSB7DQorCWNhc2UgVVBUQVJHRVRfQVBQOg0KKwkJ
c2VxX3B1dHMocywgImFwcCIpOw0KKwkJYnJlYWs7DQorCWNhc2UgVVBUQVJHRVRfTU9VTlQ6DQor
CQlzZXFfcHV0cyhzLCAibW91bnQiKTsNCisJCWJyZWFrOw0KKwlkZWZhdWx0Og0KKwkJLyogc2hv
dWxkbid0IGV2ZXIgaGFwcGVuICovDQorCQlzZXFfcHV0cyhzLCAidW5rbm93biIpOw0KKwkJYnJl
YWs7DQorCX0NCit9DQorDQogLyoNCiAgKiBjaWZzX3Nob3dfb3B0aW9ucygpIGlzIGZvciBkaXNw
bGF5aW5nIG1vdW50IG9wdGlvbnMgaW4gL3Byb2MvbW91bnRzLg0KICAqIE5vdCBhbGwgc2V0dGFi
bGUgb3B0aW9ucyBhcmUgZGlzcGxheWVkIGJ1dCBtb3N0IG9mIHRoZSBpbXBvcnRhbnQNCkBAIC01
NTEsNiArNTc1LDcgQEAgY2lmc19zaG93X29wdGlvbnMoc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1
Y3QgZGVudHJ5ICpyb290KQ0KIAlzZXFfc2hvd19vcHRpb24ocywgInZlcnMiLCB0Y29uLT5zZXMt
PnNlcnZlci0+dmFscy0+dmVyc2lvbl9zdHJpbmcpOw0KIAljaWZzX3Nob3dfc2VjdXJpdHkocywg
dGNvbi0+c2VzKTsNCiAJY2lmc19zaG93X2NhY2hlX2ZsYXZvcihzLCBjaWZzX3NiKTsNCisJY2lm
c19zaG93X3VwY2FsbF90YXJnZXQocywgY2lmc19zYik7DQogDQogCWlmICh0Y29uLT5ub19sZWFz
ZSkNCiAJCXNlcV9wdXRzKHMsICIsbm9sZWFzZSIpOw0KZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGll
bnQvY2lmc2dsb2IuaCBiL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaA0KaW5kZXggOWVhZTg2NDlm
Li43ODc4ZDExOTcgMTAwNjQ0DQotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgNCisrKyBi
L2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaA0KQEAgLTE1Myw2ICsxNTMsMTIgQEAgZW51bSBzZWN1
cml0eUVudW0gew0KIAlLZXJiZXJvcywJCS8qIEtlcmJlcm9zIHZpYSBTUE5FR08gKi8NCiB9Ow0K
IA0KK2VudW0gdXBjYWxsX3RhcmdldF9lbnVtIHsNCisJVVBUQVJHRVRfVU5TUEVDSUZJRUQsIC8q
IG5vdCBzcGVjaWZpZWQsIGRlZmF1bHRzIHRvIGFwcCAqLw0KKwlVUFRBUkdFVF9NT1VOVCwgLyog
dXBjYWxsIHRvIHRoZSBtb3VudCBuYW1lc3BhY2UgKi8NCisJVVBUQVJHRVRfQVBQLCAvKiB1cGNh
bGwgdG8gdGhlIGFwcGxpY2F0aW9uIG5hbWVzcGFjZSB3aGljaCBkaWQgdGhlIG1vdW50ICovDQor
fTsNCisNCiBlbnVtIGNpZnNfcmVwYXJzZV90eXBlIHsNCiAJQ0lGU19SRVBBUlNFX1RZUEVfTkZT
LA0KIAlDSUZTX1JFUEFSU0VfVFlQRV9XU0wsDQpAQCAtMTA4Myw2ICsxMDg5LDcgQEAgc3RydWN0
IGNpZnNfc2VzIHsNCiAJc3RydWN0IHNlc3Npb25fa2V5IGF1dGhfa2V5Ow0KIAlzdHJ1Y3QgbnRs
bXNzcF9hdXRoICpudGxtc3NwOyAvKiBjaXBoZXJ0ZXh0LCBmbGFncywgc2VydmVyIGNoYWxsZW5n
ZSAqLw0KIAllbnVtIHNlY3VyaXR5RW51bSBzZWN0eXBlOyAvKiB3aGF0IHNlY3VyaXR5IGZsYXZv
ciB3YXMgc3BlY2lmaWVkPyAqLw0KKwllbnVtIHVwY2FsbF90YXJnZXRfZW51bSB1cGNhbGxfdGFy
Z2V0OyAvKiB3aGF0IHVwY2FsbCB0YXJnZXQgd2FzIHNwZWNpZmllZD8gKi8NCiAJYm9vbCBzaWdu
OwkJLyogaXMgc2lnbmluZyByZXF1aXJlZD8gKi8NCiAJYm9vbCBkb21haW5BdXRvOjE7DQogCWJv
b2wgZXhwaXJlZF9wd2Q7ICAvKiB0cmFjayBpZiBhY2Nlc3MgZGVuaWVkIG9yIGV4cGlyZWQgcHdk
IHNvIGNhbiBrbm93IGlmIG5lZWQgdG8gdXBkYXRlICovDQpkaWZmIC0tZ2l0IGEvZnMvc21iL2Ns
aWVudC9jb25uZWN0LmMgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYw0KaW5kZXggNTM3NWIwYzFk
Li41Nzc2NmJjYTAgMTAwNjQ0DQotLS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYw0KKysrIGIv
ZnMvc21iL2NsaWVudC9jb25uZWN0LmMNCkBAIC0yMzUyLDYgKzIzNTIsMjYgQEAgY2lmc19nZXRf
c21iX3NlcyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBzbWIzX2ZzX2Nv
bnRleHQgKmN0eCkNCiANCiAJc2VzLT5zZWN0eXBlID0gY3R4LT5zZWN0eXBlOw0KIAlzZXMtPnNp
Z24gPSBjdHgtPnNpZ247DQorDQorCS8qDQorCSAqRXhwbGljaXRseSBtYXJraW5nIHVwY2FsbF90
YXJnZXQgbW91bnQgb3B0aW9uIGZvciBlYXNpZXIgaGFuZGxpbmcNCisJICogYnkgY2lmc19zcG5l
Z28uYyBhbmQgZXZlbnR1YWxseSBjaWZzLnVwY2FsbC5jDQorCSAqLw0KKw0KKwlzd2l0Y2ggKGN0
eC0+dXBjYWxsX3RhcmdldCkgew0KKwljYXNlIFVQVEFSR0VUX1VOU1BFQ0lGSUVEOiAvKiBkZWZh
dWx0IHRvIGFwcCAqLw0KKwljYXNlIFVQVEFSR0VUX0FQUDoNCisJCXNlcy0+dXBjYWxsX3Rhcmdl
dCA9IFVQVEFSR0VUX0FQUDsNCisJCWJyZWFrOw0KKwljYXNlIFVQVEFSR0VUX01PVU5UOg0KKwkJ
c2VzLT51cGNhbGxfdGFyZ2V0ID0gVVBUQVJHRVRfTU9VTlQ7DQorCQlicmVhazsNCisJZGVmYXVs
dDoNCisJCS8vIHNob3VsZCBuZXZlciBoYXBwZW4NCisJCXNlcy0+dXBjYWxsX3RhcmdldCA9IFVQ
VEFSR0VUX0FQUDsNCisJCWJyZWFrOw0KKwl9DQorDQogCXNlcy0+bG9jYWxfbmxzID0gbG9hZF9u
bHMoY3R4LT5sb2NhbF9ubHMtPmNoYXJzZXQpOw0KIA0KIAkvKiBhZGQgc2VydmVyIGFzIGZpcnN0
IGNoYW5uZWwgKi8NCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuYyBiL2Zz
L3NtYi9jbGllbnQvZnNfY29udGV4dC5jDQppbmRleCBiYzkyNmFiMjUuLjJiYWU0OTUwNyAxMDA2
NDQNCi0tLSBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jDQorKysgYi9mcy9zbWIvY2xpZW50
L2ZzX2NvbnRleHQuYw0KQEAgLTY3LDYgKzY3LDEyIEBAIHN0YXRpYyBjb25zdCBtYXRjaF90YWJs
ZV90IGNpZnNfc2VjZmxhdm9yX3Rva2VucyA9IHsNCiAJeyBPcHRfc2VjX2VyciwgTlVMTCB9DQog
fTsNCiANCitzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCBjaWZzX3VwY2FsbF90YXJnZXQgPSB7
DQorCXsgT3B0X3VwY2FsbF90YXJnZXRfbW91bnQsICJtb3VudCIgfSwNCisJeyBPcHRfdXBjYWxs
X3RhcmdldF9hcHBsaWNhdGlvbiwgImFwcCIgfSwNCisJeyBPcHRfdXBjYWxsX3RhcmdldF9lcnIs
IE5VTEwgfQ0KK307DQorDQogY29uc3Qgc3RydWN0IGZzX3BhcmFtZXRlcl9zcGVjIHNtYjNfZnNf
cGFyYW1ldGVyc1tdID0gew0KIAkvKiBNb3VudCBvcHRpb25zIHRoYXQgdGFrZSBubyBhcmd1bWVu
dHMgKi8NCiAJZnNwYXJhbV9mbGFnX25vKCJ1c2VyX3hhdHRyIiwgT3B0X3VzZXJfeGF0dHIpLA0K
QEAgLTE3OCw2ICsxODQsNyBAQCBjb25zdCBzdHJ1Y3QgZnNfcGFyYW1ldGVyX3NwZWMgc21iM19m
c19wYXJhbWV0ZXJzW10gPSB7DQogCWZzcGFyYW1fc3RyaW5nKCJzZWMiLCBPcHRfc2VjKSwNCiAJ
ZnNwYXJhbV9zdHJpbmcoImNhY2hlIiwgT3B0X2NhY2hlKSwNCiAJZnNwYXJhbV9zdHJpbmcoInJl
cGFyc2UiLCBPcHRfcmVwYXJzZSksDQorCWZzcGFyYW1fc3RyaW5nKCJ1cGNhbGxfdGFyZ2V0Iiwg
T3B0X3VwY2FsbHRhcmdldCksDQogDQogCS8qIEFyZ3VtZW50cyB0aGF0IHNob3VsZCBiZSBpZ25v
cmVkICovDQogCWZzcGFyYW1fZmxhZygiZ3Vlc3QiLCBPcHRfaWdub3JlKSwNCkBAIC0yNDgsNiAr
MjU1LDI5IEBAIGNpZnNfcGFyc2Vfc2VjdXJpdHlfZmxhdm9ycyhzdHJ1Y3QgZnNfY29udGV4dCAq
ZmMsIGNoYXIgKnZhbHVlLCBzdHJ1Y3Qgc21iM19mc19jDQogCXJldHVybiAwOw0KIH0NCiANCitz
dGF0aWMgaW50DQorY2lmc19wYXJzZV91cGNhbGxfdGFyZ2V0KHN0cnVjdCBmc19jb250ZXh0ICpm
YywgY2hhciAqdmFsdWUsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkNCit7DQorCXN1YnN0
cmluZ190IGFyZ3NbTUFYX09QVF9BUkdTXTsNCisNCisJY3R4LT51cGNhbGxfdGFyZ2V0ID0gVVBU
QVJHRVRfVU5TUEVDSUZJRUQ7DQorDQorCXN3aXRjaCAobWF0Y2hfdG9rZW4odmFsdWUsIGNpZnNf
dXBjYWxsX3RhcmdldCwgYXJncykpIHsNCisJY2FzZSBPcHRfdXBjYWxsX3RhcmdldF9tb3VudDoN
CisJCWN0eC0+dXBjYWxsX3RhcmdldCA9IFVQVEFSR0VUX01PVU5UOw0KKwkJYnJlYWs7DQorCWNh
c2UgT3B0X3VwY2FsbF90YXJnZXRfYXBwbGljYXRpb246DQorCQljdHgtPnVwY2FsbF90YXJnZXQg
PSBVUFRBUkdFVF9BUFA7DQorCQlicmVhazsNCisNCisJZGVmYXVsdDoNCisJCWNpZnNfZXJyb3Jm
KGZjLCAiYmFkIHVwY2FsbCB0YXJnZXQ6ICVzXG4iLCB2YWx1ZSk7DQorCQlyZXR1cm4gMTsNCisJ
fQ0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGNvbnN0IG1hdGNoX3RhYmxlX3QgY2lm
c19jYWNoZWZsYXZvcl90b2tlbnMgPSB7DQogCXsgT3B0X2NhY2hlX2xvb3NlLCAibG9vc2UiIH0s
DQogCXsgT3B0X2NhY2hlX3N0cmljdCwgInN0cmljdCIgfSwNCkBAIC0xNDQwLDYgKzE0NzAsMTAg
QEAgc3RhdGljIGludCBzbWIzX2ZzX2NvbnRleHRfcGFyc2VfcGFyYW0oc3RydWN0IGZzX2NvbnRl
eHQgKmZjLA0KIAkJaWYgKGNpZnNfcGFyc2Vfc2VjdXJpdHlfZmxhdm9ycyhmYywgcGFyYW0tPnN0
cmluZywgY3R4KSAhPSAwKQ0KIAkJCWdvdG8gY2lmc19wYXJzZV9tb3VudF9lcnI7DQogCQlicmVh
azsNCisJY2FzZSBPcHRfdXBjYWxsdGFyZ2V0Og0KKwkJaWYgKGNpZnNfcGFyc2VfdXBjYWxsX3Rh
cmdldChmYywgcGFyYW0tPnN0cmluZywgY3R4KSAhPSAwKQ0KKwkJCWdvdG8gY2lmc19wYXJzZV9t
b3VudF9lcnI7DQorCQlicmVhazsNCiAJY2FzZSBPcHRfY2FjaGU6DQogCQlpZiAoY2lmc19wYXJz
ZV9jYWNoZV9mbGF2b3IoZmMsIHBhcmFtLT5zdHJpbmcsIGN0eCkgIT0gMCkNCiAJCQlnb3RvIGNp
ZnNfcGFyc2VfbW91bnRfZXJyOw0KQEAgLTE2MTcsNiArMTY1MSwxMSBAQCBzdGF0aWMgaW50IHNt
YjNfZnNfY29udGV4dF9wYXJzZV9wYXJhbShzdHJ1Y3QgZnNfY29udGV4dCAqZmMsDQogCX0NCiAJ
LyogY2FzZSBPcHRfaWdub3JlOiAtIGlzIGlnbm9yZWQgYXMgZXhwZWN0ZWQgLi4uICovDQogDQor
CWlmIChjdHgtPm11bHRpdXNlciAmJiBjdHgtPnVwY2FsbF90YXJnZXQgPT0gVVBUQVJHRVRfTU9V
TlQpIHsNCisJCWNpZnNfZXJyb3JmKGZjLCAibXVsdGl1c2VyIG1vdW50IG9wdGlvbiBub3Qgc3Vw
cG9ydGVkIHdpdGggdXBjYWxsdGFyZ2V0IHNldCBhcyAnbW91bnQnXG4iKTsNCisJCWdvdG8gY2lm
c19wYXJzZV9tb3VudF9lcnI7DQorCX0NCisNCiAJcmV0dXJuIDA7DQogDQogIGNpZnNfcGFyc2Vf
bW91bnRfZXJyOg0KZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5oIGIvZnMv
c21iL2NsaWVudC9mc19jb250ZXh0LmgNCmluZGV4IGNmNTc3ZWMwZC4uZTNjZWVkNDhjIDEwMDY0
NA0KLS0tIGEvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmgNCisrKyBiL2ZzL3NtYi9jbGllbnQv
ZnNfY29udGV4dC5oDQpAQCAtNjEsNiArNjEsMTIgQEAgZW51bSBjaWZzX3NlY19wYXJhbSB7DQog
CU9wdF9zZWNfZXJyDQogfTsNCiANCitlbnVtIGNpZnNfdXBjYWxsX3RhcmdldF9wYXJhbSB7DQor
CU9wdF91cGNhbGxfdGFyZ2V0X21vdW50LA0KKwlPcHRfdXBjYWxsX3RhcmdldF9hcHBsaWNhdGlv
biwNCisJT3B0X3VwY2FsbF90YXJnZXRfZXJyDQorfTsNCisNCiBlbnVtIGNpZnNfcGFyYW0gew0K
IAkvKiBNb3VudCBvcHRpb25zIHRoYXQgdGFrZSBubyBhcmd1bWVudHMgKi8NCiAJT3B0X3VzZXJf
eGF0dHIsDQpAQCAtMTE0LDYgKzEyMCw4IEBAIGVudW0gY2lmc19wYXJhbSB7DQogCU9wdF9tdWx0
aWNoYW5uZWwsDQogCU9wdF9jb21wcmVzcywNCiAJT3B0X3dpdG5lc3MsDQorCU9wdF9pc191cGNh
bGxfdGFyZ2V0X21vdW50LA0KKwlPcHRfaXNfdXBjYWxsX3RhcmdldF9hcHBsaWNhdGlvbiwNCiAN
CiAJLyogTW91bnQgb3B0aW9ucyB3aGljaCB0YWtlIG51bWVyaWMgdmFsdWUgKi8NCiAJT3B0X2Jh
Y2t1cHVpZCwNCkBAIC0xNTcsNiArMTY1LDcgQEAgZW51bSBjaWZzX3BhcmFtIHsNCiAJT3B0X3Nl
YywNCiAJT3B0X2NhY2hlLA0KIAlPcHRfcmVwYXJzZSwNCisJT3B0X3VwY2FsbHRhcmdldCwNCiAN
CiAJLyogTW91bnQgb3B0aW9ucyB0byBiZSBpZ25vcmVkICovDQogCU9wdF9pZ25vcmUsDQpAQCAt
MTk4LDYgKzIwNyw3IEBAIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgew0KIAl1bW9kZV90IGZpbGVf
bW9kZTsNCiAJdW1vZGVfdCBkaXJfbW9kZTsNCiAJZW51bSBzZWN1cml0eUVudW0gc2VjdHlwZTsg
Lyogc2VjdHlwZSByZXF1ZXN0ZWQgdmlhIG1udCBvcHRzICovDQorCWVudW0gdXBjYWxsX3Rhcmdl
dF9lbnVtIHVwY2FsbF90YXJnZXQ7IC8qIHdoZXJlIHRvIHVwY2FsbCBmb3IgbW91bnQgKi8NCiAJ
Ym9vbCBzaWduOyAvKiB3YXMgc2lnbmluZyByZXF1ZXN0ZWQgdmlhIG1udCBvcHRzPyAqLw0KIAli
b29sIGlnbm9yZV9zaWduYXR1cmU6MTsNCiAJYm9vbCByZXRyeToxOw0KLS0gDQoyLjQzLjANCg0K
--000000000000f943e106273e2b0f--
