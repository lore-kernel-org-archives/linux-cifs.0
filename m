Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7571FF5EA
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 11:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498209; cv=none; b=rfXjsLtoQEcfnONNYdDxQkKe7qeks2puZ2k2U5Rd56stozlZ+pSOSUMKXM9QA72TmZXKk+CeBgmus0kaZVD8BDekdeAER9oQRAIEGbPA6mBGIAbDm9skjPsYXFbjWFd3AxvD6Rv7RUGXKT+hU09pYkqSec7RCQpROpcNfArC55Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498209; c=relaxed/simple;
	bh=VTT+vBl8cPVjLjBb2XRgztHd8v1LyZCzbo/7pEqvwgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwnHkqkCCvSYVcpaiIfF8T5By43yxB/jSIUn9kzTFwRRc3k9mIuO0LuDDwQYpgy3EC08HA96zKNOEt0QDWhhb0l6boTeYtDmsblL3O9eMsVWZM//AOyGtlfdiatJ6GrjEE+jWG6F8Pc94f8ngEGmRiFdrzwFx6lafE5g/Y+eEWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RodHBuX+; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RodHBuX+"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5cec9609303so8245788a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 03:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731498206; x=1732103006; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3f2oX5M69z9/q+G+sWc5llcJtaKWjfTiI/4KtQkcw8c=;
        b=RodHBuX+TDoqJwGVBAw5X0bYO1pC2dbNrRXUdQO/+ascljZvmOXZgmWPzdwFbqLgtv
         QQftxwDc3WzHHRT1mxcuSaOZna1TP7tolMfMbENZjyS2twgozL1lWVi4F4e92GxYaPPh
         0gl5VIVzclO5Y412UuyvgpemHdes0HxhYc/kpBA0Wdpii384F8udgtQ58YXwjTVf/OK5
         lmXkQhBZ9wL3tCeLrNasthttactTd5Murf2VjfvC7dapTZHStqVrRQJ9VFnDQCDfJrkT
         eC+JZZKt8dCh8bybsEwdo2pM2P+qbuzDGJ+6Q43XGHCql8Smjoj5v7ziln4+wXERxekI
         Pabw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731498206; x=1732103006;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3f2oX5M69z9/q+G+sWc5llcJtaKWjfTiI/4KtQkcw8c=;
        b=Cvt3jrxRNh9MObNlK3ziZBfRw9ZjgggQ4UNwANqzwn7vvKgxxzwU2ufjPFLbB1niob
         +e3HYct63VrvYxh3Y8BegoFm+Wj8ejIj4b8552OlDcfQgzcWNtSUDYmFquuGea+yaZXj
         Fpeq1qrv/zg6fAS8s7PUTUEHJijGlZgjbQYbtn18xzDzBcbsu2AxbHLFoQMpFSQV/Kxi
         peXu3f1MuvK/+aan+RBZWtnkiy2o5BtCYqfkH/RJgUc+GFi1VBHS6RptpRUfDw3mL7nM
         ZYY5252Rkc4zTICh3+h0Es/QN4ijR6F3C5y3ZSXoGgQ8ZGAy4G8JoXFd6R9hlGHeyEms
         64HA==
X-Forwarded-Encrypted: i=1; AJvYcCUTitfIlyc5BOZkzMOstmEQZtg+0+/ueD7ndMNc7VfI23DwnatecW5F9VXxnw/i0VHt7yDOrCabE+0w@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8J7VR4Bv7atjtA09AlRaKIWGYnIPkHSSHLku+vz0f3xP++WAX
	/Wgyw8D4Em+BAMbruHd5CLTHZClr7tXT1EFChFSNfGYqwjTLlGJ1nbFSt2/VDQnrUz83qTYJCDF
	PCgFqfePVd2pctavoa2JawCm0P6pB+Q==
X-Google-Smtp-Source: AGHT+IH7LvZT3YwJE2Cgw53eiL+vMfCm5FLkZwFKLiZuMnmQvtvlTtxQmrsG+zOAml6kECW9Gn7kld9fpm7Glurb9Vc=
X-Received: by 2002:a05:6402:5241:b0:5ce:dea8:8eb with SMTP id
 4fb4d7f45d1cf-5cf0a26e1d9mr14653616a12.0.1731498205693; Wed, 13 Nov 2024
 03:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <20241030142829.234828-2-meetakshisetiyaoss@gmail.com> <0282479bc2f446bcb34c53a30bb53bda@manguebit.com>
 <CANT5p=qJ+zAU_0bMx=5uhsD1a5BR4Nj8Uv0KvNPOBNt9AtPs6w@mail.gmail.com> <cc06137a94a01901ff5cd9de6a223675@manguebit.com>
In-Reply-To: <cc06137a94a01901ff5cd9de6a223675@manguebit.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 13 Nov 2024 17:13:13 +0530
Message-ID: <CAFTVevWw0R+=DV76gecOvRtEqAX-htDwikt2DgPiMjwKo2HLhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: support mounting with alternate password to
 allow password rotation
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com, sfrench@samba.org, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000007ae7160626c9d7f5"

--0000000000007ae7160626c9d7f5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review Paulo, here is the updated patch that uses
cifs_dbg (FYI) instead of cifs_info.

Best
Meetakshi

On Fri, Nov 8, 2024 at 8:50=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > On Fri, Nov 8, 2024 at 12:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.c=
om> wrote:
> >>
> >> meetakshisetiyaoss@gmail.com writes:
> >>
> >> > @@ -2245,6 +2269,7 @@ struct cifs_ses *
> >> >  cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_con=
text *ctx)
> >> >  {
> >> >       int rc =3D 0;
> >> > +     int retries =3D 0;
> >> >       unsigned int xid;
> >> >       struct cifs_ses *ses;
> >> >       struct sockaddr_in *addr =3D (struct sockaddr_in *)&server->ds=
taddr;
> >> > @@ -2263,6 +2288,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *serve=
r, struct smb3_fs_context *ctx)
> >> >                       cifs_dbg(FYI, "Session needs reconnect\n");
> >> >
> >> >                       mutex_lock(&ses->session_mutex);
> >> > +
> >> > +retry_old_session:
> >> >                       rc =3D cifs_negotiate_protocol(xid, ses, serve=
r);
> >> >                       if (rc) {
> >> >                               mutex_unlock(&ses->session_mutex);
> >> > @@ -2275,6 +2302,13 @@ cifs_get_smb_ses(struct TCP_Server_Info *serv=
er, struct smb3_fs_context *ctx)
> >> >                       rc =3D cifs_setup_session(xid, ses, server,
> >> >                                               ctx->local_nls);
> >> >                       if (rc) {
> >> > +                             if (((rc =3D=3D -EACCES) || (rc =3D=3D=
 -EKEYEXPIRED) ||
> >> > +                                     (rc =3D=3D -EKEYREVOKED)) && !=
retries && ses->password2) {
> >> > +                                     retries++;
> >> > +                                     cifs_info("Session reconnect f=
ailed, retrying with alternate password\n");
> >>
> >> Please don't add more noisy messages over reconnect.  Remember that if
> >> SMB session doesn't get re-established, there will be flood enough on
> >> dmesg with "Send error in SessSetup =3D ..." messages on every 2s that
> >> already pisses off users and customers.
> >>
> > Perhaps we could do a cifs_dbg instead of cifs_info.
>
> Yep, with FYI.
>
> > But Paulo, the problem here is that we retry every 2s. I think we
> > should address that instead.
> > One way is to do an exponential backoff every time we retry.
>
> Agreed, but that doesn't mean we should add more noisy messages.
>
> > I'd also want to understand why we need the reconnect work?
>
> I see it as an optimisation to allow next IOs to not take longer because
> it needs to reconnect SMB session.  If there was no prior filesystem
> activity, why don't allow the client itself to reconnect the session?
>
> Besides, SMB2_IOCTL currently doesn't call smb2_reconnect(), so
> reconnect worker would be required to reconnect the session and then
> allow SMB2_IOCTL to work.  We'd need to change that because with recent
> special file support, we need to avoid failures when creating or parsing
> reparse points because the SMB session isn't re-established yet.
>
> > Why not always do smb2_reconnect when someone does filesystem calls on
> > the mount point?
>
> We already do for most operations.  SMB2_IOCTL and SMB2_TREE_CONNECT,
> for instance, can't call smb2_reconnect() as they would deadlock.

--0000000000007ae7160626c9d7f5
Content-Type: application/octet-stream; 
	name="0002-cifs-support-mounting-with-alternate-password-to-all.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-support-mounting-with-alternate-password-to-all.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3ft9sur0>
X-Attachment-Id: f_m3ft9sur0

RnJvbSAzMmY2ZTI5M2Y4ZjQ5ZjY2ZmE0ZGYxN2MyYWE4MTU2OWM3ZDc3NTJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZWV0YWtzaGkgU2V0aXlhIDxtc2V0aXlhQG1pY3Jvc29mdC5j
b20+CkRhdGU6IFdlZCwgMzAgT2N0IDIwMjQgMDU6Mzc6MjEgLTA0MDAKU3ViamVjdDogW1BBVENI
IDIvMl0gY2lmczogc3VwcG9ydCBtb3VudGluZyB3aXRoIGFsdGVybmF0ZSBwYXNzd29yZCB0byBh
bGxvdwogcGFzc3dvcmQgcm90YXRpb24KClRoaXMgcGF0Y2ggaW50cm9kdWNlcyB0aGUgZm9sbG93
aW5nIGNoYW5nZXMgdG8gc3VwcG9ydCBwYXNzd29yZCByb3RhdGlvbiBvbgptb3VudDoKCjEuIElm
IGFuIGV4aXN0aW5nIHNlc3Npb24gaXMgbm90IGZvdW5kIGFuZCB0aGUgbmV3IHNlc3Npb24gc2V0
dXAgcmVzdWx0cyBpbgpFQUNDRVMsIEVLRVlFWFBJUkVEIG9yIEVLRVlSRVZPS0VELCBzd2FwIHBh
c3N3b3JkIGFuZCBwYXNzd29yZDIgKGlmCmF2YWlsYWJsZSksIGFuZCByZXRyeSB0aGUgbW91bnQu
CgoyLiBUbyBtYXRjaCB0aGUgbmV3IG1vdW50IHdpdGggYW4gZXhpc3Rpbmcgc2Vzc2lvbiwgYWRk
IGNvbmRpdGlvbnMgdG8gY2hlY2sKaWYgYSkgcGFzc3dvcmQgYW5kIHBhc3N3b3JkMiBvZiB0aGUg
bmV3IG1vdW50IGFuZCB0aGUgZXhpc3Rpbmcgc2Vzc2lvbiBhcmUKdGhlIHNhbWUsIG9yIGIpIHBh
c3N3b3JkIG9mIHRoZSBuZXcgbW91bnQgaXMgdGhlIHNhbWUgYXMgdGhlIHBhc3N3b3JkMiBvZgp0
aGUgZXhpc3Rpbmcgc2Vzc2lvbiwgYW5kIHBhc3N3b3JkMiBvZiB0aGUgbmV3IG1vdW50IGlzIHRo
ZSBzYW1lIGFzIHRoZQpwYXNzd29yZCBvZiB0aGUgZXhpc3Rpbmcgc2Vzc2lvbi4KCjMuIElmIGFu
IGV4aXN0aW5nIHNlc3Npb24gaXMgZm91bmQsIGJ1dCBuZWVkcyByZWNvbm5lY3QsIHJldHJ5IHRo
ZSBzZXNzaW9uCnNldHVwIGFmdGVyIHN3YXBwaW5nIHBhc3N3b3JkIGFuZCBwYXNzd29yZDIgKGlm
IGF2YWlsYWJsZSksIGluIGNhc2UgdGhlCnByZXZpb3VzIGF0dGVtcHQgcmVzdWx0cyBpbiBFQUND
RVMsIEVLRVlFWFBJUkVEIG9yIEVLRVlSRVZPS0VELgoKU2lnbmVkLW9mZi1ieTogTWVldGFrc2hp
IFNldGl5YSA8bXNldGl5YUBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY29ubmVj
dC5jIHwgNTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCA1MCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKaW5kZXgg
MTVkOTRhYzQwOTVlLi4wMjlkZGIzNThiZTAgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY29u
bmVjdC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY29ubmVjdC5jCkBAIC0xODk4LDExICsxODk4LDM1
IEBAIHN0YXRpYyBpbnQgbWF0Y2hfc2Vzc2lvbihzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJCSAg
ICBDSUZTX01BWF9VU0VSTkFNRV9MRU4pKQogCQkJcmV0dXJuIDA7CiAJCWlmICgoY3R4LT51c2Vy
bmFtZSAmJiBzdHJsZW4oY3R4LT51c2VybmFtZSkgIT0gMCkgJiYKLQkJICAgIHNlcy0+cGFzc3dv
cmQgIT0gTlVMTCAmJgotCQkgICAgc3RybmNtcChzZXMtPnBhc3N3b3JkLAotCQkJICAgIGN0eC0+
cGFzc3dvcmQgPyBjdHgtPnBhc3N3b3JkIDogIiIsCi0JCQkgICAgQ0lGU19NQVhfUEFTU1dPUkRf
TEVOKSkKLQkJCXJldHVybiAwOworCQkgICAgc2VzLT5wYXNzd29yZCAhPSBOVUxMKSB7CisKKwkJ
CS8qIE5ldyBtb3VudCBjYW4gb25seSBzaGFyZSBzZXNzaW9ucyB3aXRoIGFuIGV4aXN0aW5nIG1v
dW50IGlmOgorCQkJICogMS4gQm90aCBwYXNzd29yZCBhbmQgcGFzc3dvcmQyIG1hdGNoLCBvcgor
CQkJICogMi4gcGFzc3dvcmQyIG9mIHRoZSBvbGQgbW91bnQgbWF0Y2hlcyBwYXNzd29yZCBvZiB0
aGUgbmV3IG1vdW50CisJCQkgKiAgICBhbmQgcGFzc3dvcmQgb2YgdGhlIG9sZCBtb3VudCBtYXRj
aGVzIHBhc3N3b3JkMiBvZiB0aGUgbmV3CisJCQkgKgkgIG1vdW50CisJCQkgKi8KKwkJCWlmIChz
ZXMtPnBhc3N3b3JkMiAhPSBOVUxMICYmIGN0eC0+cGFzc3dvcmQyICE9IE5VTEwpIHsKKwkJCQlp
ZiAoISgoc3RybmNtcChzZXMtPnBhc3N3b3JkLCBjdHgtPnBhc3N3b3JkID8KKwkJCQkJY3R4LT5w
YXNzd29yZCA6ICIiLCBDSUZTX01BWF9QQVNTV09SRF9MRU4pID09IDAgJiYKKwkJCQkJc3RybmNt
cChzZXMtPnBhc3N3b3JkMiwgY3R4LT5wYXNzd29yZDIsCisJCQkJCUNJRlNfTUFYX1BBU1NXT1JE
X0xFTikgPT0gMCkgfHwKKwkJCQkJKHN0cm5jbXAoc2VzLT5wYXNzd29yZCwgY3R4LT5wYXNzd29y
ZDIsCisJCQkJCUNJRlNfTUFYX1BBU1NXT1JEX0xFTikgPT0gMCAmJgorCQkJCQlzdHJuY21wKHNl
cy0+cGFzc3dvcmQyLCBjdHgtPnBhc3N3b3JkID8KKwkJCQkJY3R4LT5wYXNzd29yZCA6ICIiLCBD
SUZTX01BWF9QQVNTV09SRF9MRU4pID09IDApKSkKKwkJCQkJcmV0dXJuIDA7CisKKwkJCX0gZWxz
ZSBpZiAoKHNlcy0+cGFzc3dvcmQyID09IE5VTEwgJiYgY3R4LT5wYXNzd29yZDIgIT0gTlVMTCkg
fHwKKwkJCQkoc2VzLT5wYXNzd29yZDIgIT0gTlVMTCAmJiBjdHgtPnBhc3N3b3JkMiA9PSBOVUxM
KSkgeworCQkJCXJldHVybiAwOworCisJCQl9IGVsc2UgeworCQkJCWlmIChzdHJuY21wKHNlcy0+
cGFzc3dvcmQsIGN0eC0+cGFzc3dvcmQgPworCQkJCQljdHgtPnBhc3N3b3JkIDogIiIsIENJRlNf
TUFYX1BBU1NXT1JEX0xFTikpCisJCQkJCXJldHVybiAwOworCQkJfQorCQl9CiAJfQogCiAJaWYg
KHN0cmNtcChjdHgtPmxvY2FsX25scy0+Y2hhcnNldCwgc2VzLT5sb2NhbF9ubHMtPmNoYXJzZXQp
KQpAQCAtMjI0NSw2ICsyMjY5LDcgQEAgc3RydWN0IGNpZnNfc2VzICoKIGNpZnNfZ2V0X3NtYl9z
ZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0
ICpjdHgpCiB7CiAJaW50IHJjID0gMDsKKwlpbnQgcmV0cmllcyA9IDA7CiAJdW5zaWduZWQgaW50
IHhpZDsKIAlzdHJ1Y3QgY2lmc19zZXMgKnNlczsKIAlzdHJ1Y3Qgc29ja2FkZHJfaW4gKmFkZHIg
PSAoc3RydWN0IHNvY2thZGRyX2luICopJnNlcnZlci0+ZHN0YWRkcjsKQEAgLTIyNjMsNiArMjI4
OCw4IEBAIGNpZnNfZ2V0X3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBz
dHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJCQljaWZzX2RiZyhGWUksICJTZXNzaW9uIG5l
ZWRzIHJlY29ubmVjdFxuIik7CiAKIAkJCW11dGV4X2xvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7
CisKK3JldHJ5X29sZF9zZXNzaW9uOgogCQkJcmMgPSBjaWZzX25lZ290aWF0ZV9wcm90b2NvbCh4
aWQsIHNlcywgc2VydmVyKTsKIAkJCWlmIChyYykgewogCQkJCW11dGV4X3VubG9jaygmc2VzLT5z
ZXNzaW9uX211dGV4KTsKQEAgLTIyNzUsNiArMjMwMiwxMyBAQCBjaWZzX2dldF9zbWJfc2VzKHN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4
KQogCQkJcmMgPSBjaWZzX3NldHVwX3Nlc3Npb24oeGlkLCBzZXMsIHNlcnZlciwKIAkJCQkJCWN0
eC0+bG9jYWxfbmxzKTsKIAkJCWlmIChyYykgeworCQkJCWlmICgoKHJjID09IC1FQUNDRVMpIHx8
IChyYyA9PSAtRUtFWUVYUElSRUQpIHx8CisJCQkJCShyYyA9PSAtRUtFWVJFVk9LRUQpKSAmJiAh
cmV0cmllcyAmJiBzZXMtPnBhc3N3b3JkMikgeworCQkJCQlyZXRyaWVzKys7CisJCQkJCWNpZnNf
ZGJnKEZZSSwgIlNlc3Npb24gcmVjb25uZWN0IGZhaWxlZCwgcmV0cnlpbmcgd2l0aCBhbHRlcm5h
dGUgcGFzc3dvcmRcbiIpOworCQkJCQlzd2FwKHNlcy0+cGFzc3dvcmQsIHNlcy0+cGFzc3dvcmQy
KTsKKwkJCQkJZ290byByZXRyeV9vbGRfc2Vzc2lvbjsKKwkJCQl9CiAJCQkJbXV0ZXhfdW5sb2Nr
KCZzZXMtPnNlc3Npb25fbXV0ZXgpOwogCQkJCS8qIHByb2JsZW0gLS0gcHV0IG91ciByZWZlcmVu
Y2UgKi8KIAkJCQljaWZzX3B1dF9zbWJfc2VzKHNlcyk7CkBAIC0yMzUwLDYgKzIzODQsNyBAQCBj
aWZzX2dldF9zbWJfc2VzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IHNt
YjNfZnNfY29udGV4dCAqY3R4KQogCXNlcy0+Y2hhbnNfbmVlZF9yZWNvbm5lY3QgPSAxOwogCXNw
aW5fdW5sb2NrKCZzZXMtPmNoYW5fbG9jayk7CiAKK3JldHJ5X25ld19zZXNzaW9uOgogCW11dGV4
X2xvY2soJnNlcy0+c2Vzc2lvbl9tdXRleCk7CiAJcmMgPSBjaWZzX25lZ290aWF0ZV9wcm90b2Nv
bCh4aWQsIHNlcywgc2VydmVyKTsKIAlpZiAoIXJjKQpAQCAtMjM2Miw4ICsyMzk3LDE2IEBAIGNp
ZnNfZ2V0X3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3Qgc21i
M19mc19jb250ZXh0ICpjdHgpCiAJICAgICAgIHNpemVvZihzZXMtPnNtYjNzaWduaW5na2V5KSk7
CiAJc3Bpbl91bmxvY2soJnNlcy0+Y2hhbl9sb2NrKTsKIAotCWlmIChyYykKLQkJZ290byBnZXRf
c2VzX2ZhaWw7CisJaWYgKHJjKSB7CisJCWlmICgoKHJjID09IC1FQUNDRVMpIHx8IChyYyA9PSAt
RUtFWUVYUElSRUQpIHx8CisJCQkocmMgPT0gLUVLRVlSRVZPS0VEKSkgJiYgIXJldHJpZXMgJiYg
c2VzLT5wYXNzd29yZDIpIHsKKwkJCXJldHJpZXMrKzsKKwkJCWNpZnNfZGJnKEZZSSwgIlNlc3Np
b24gc2V0dXAgZmFpbGVkLCByZXRyeWluZyB3aXRoIGFsdGVybmF0ZSBwYXNzd29yZFxuIik7CisJ
CQlzd2FwKHNlcy0+cGFzc3dvcmQsIHNlcy0+cGFzc3dvcmQyKTsKKwkJCWdvdG8gcmV0cnlfbmV3
X3Nlc3Npb247CisJCX0gZWxzZQorCQkJZ290byBnZXRfc2VzX2ZhaWw7CisJfQogCiAJLyoKIAkg
KiBzdWNjZXNzLCBwdXQgaXQgb24gdGhlIGxpc3QgYW5kIGFkZCBpdCBhcyBmaXJzdCBjaGFubmVs
Ci0tIAoyLjQ2LjAuNDYuZzQwNmYzMjZkMjcKCg==
--0000000000007ae7160626c9d7f5--
