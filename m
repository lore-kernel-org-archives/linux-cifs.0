Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0414A3408
	for <linux-cifs@vger.kernel.org>; Wed,  6 May 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778087239; cv=pass; b=NMo8JIXzTyKcjdbtq9otOa7wkFdq8WsXlr3H/OWad95mhzEBNmWlDjBeinvNxkIj696UqiseS5OxNRS+bmZk1BA/Ax002llhKf9WblhiqgpzBFjTgNIeWn3BVBKJYZPmGbehN1+PorpTXqp0IhOO6k5GgZsm6JywZsdTLWyiIys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778087239; c=relaxed/simple;
	bh=DQbQtb1aeSNig4nDF0nhCiATDIaGKwY6MHNNc+ENaqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XALeswk1Lekch9zFaa8b5qwXttUm+x5oZEGPghDmfpv2NKc0Fw3AZOBl+uv+IELD6sd0TpE4m1j/+je32gSMihvkPt7FT0J4uZh3i6AA552z1/i//xCrxqim/dVurV7TEEf0Yfg5oJM4QS3rewYbRf+kOEtpDMBLkqL/WpWj6v8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lhVE2k+t; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhVE2k+t"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b8e98fd885so33201926d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 06 May 2026 10:07:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778087225; cv=none;
        d=google.com; s=arc-20240605;
        b=MW8WgrQ+GLKf9yRQIayh8yJUWJZxW89KJurqoBtAqDBzc1RTo3GVOtMyxTxlXiUxP8
         vQq6KAXU7JgU5s5jNtyx+HO0SyCWEaAn/S92o//uHK+ts6lhXNEQdxY9Ckd0Zghf0LtP
         b6s6XDyWCtuEG8k/gzfROi/n/ze15sNWDcp71u3PdWCqvoHMRi7YlslYDiclClXihTtZ
         HpDGO0O7Zka1pdf4SMV7aGCKsT59RnD0JPed6oDm6w/iit0pqCLxXKAhdzP8K9fFc5Su
         2oqL4Lz89IjexXPUjHARX+gsb9mLLxtC65ajY8YSMWXjBQAdQ0evzxiPTy2VuCF5B3c9
         fQHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zPFV8jj+ekv3Log2QoWLrDpVl+QYXqF+SrdiEP1ybsQ=;
        fh=3vIiZtO5tRCd959K3hFOFzSpgKX+YftKuaVlxNkgsUU=;
        b=WeVALRXgSsHKihb8kkcibFgK69RACkGvu3mF/ZMxFkEscAyN9naB2W8fhl8g5xG/lO
         4lwDGvtUzEhKaQQjn1pNt4YOeofv779ohaE2JtLAfcQP1yw6qKpDOhLqzWjFUBu4J+yJ
         8x3FBLs3sMLDnyKBaeYo1PjP/Wyp2jbFuKTWBw6t0pawpPJz949N+xqeFnYFVsIT2uE1
         +wrlx4P7bfClDfpgsRwcBlgk+hhGElwQ/2ix+v0XjwCEHtM6NiDtV6TVDmQt4vefETE8
         3oJx6CukgX1dK7YDxQDTt3GrwQt3g+Qho0P2Dgr+uduiBPqD8qc7lzV1fwGNEMgrt3Zf
         sWgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778087225; x=1778692025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPFV8jj+ekv3Log2QoWLrDpVl+QYXqF+SrdiEP1ybsQ=;
        b=lhVE2k+tSeJg0sWDHAOuqDAa6R+JYrC55cSNafWmwqv19IS4++NtkH1pHgZewlL8iB
         6YkpybGAojbT6ZzJ7mCgIsAYHnWO+GzwyCrlPxn7uYtnkzeRaZEb0I1eT0v2Yo2zDBEF
         qP6/Voa7f/KbdBatJVIJZFIdZZRfOwHCDHTMomjSZBkY/PlShyMVwzZa9jCTlEHZQuzt
         LHpCncs2AOUFcT+XT4HDH32eeagPrHyFkHaiyXhtdMG0H+23octvmy+ltchfEJuaNbig
         pCxBF22Fq6vxbx5cypen47ARnWkzLH8c//8fsC8ccUM4diTJLFK1GcyduNY2A+YZmLpB
         88aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778087225; x=1778692025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zPFV8jj+ekv3Log2QoWLrDpVl+QYXqF+SrdiEP1ybsQ=;
        b=Wf5887KqtD6HgmimmLNoMHGeobWGS0M5pAp9qGU+7g5uKQiPgcpCsIrud1otbFp9IB
         bXW3+SeVFxz84bshRRYcDR4IHkfxhNfl7114Xn/rJmKDVTryMkcK61W62m4nqTkMEOgI
         B5NBpqDn2WU/S2+Buls3f4egORctQnbGlr0bg2XIaJcS4qW2ROZXjn40tnQDFofopPYC
         V48yv8yCpclfevAKPFPj56KRdiC7xaGRjacb8QjVGbjmWcASuzq/dmufSHfxB8KuMZ6D
         SmGedu/VTCPN2l8UAWNIGhiXGoezcgOLdRyURAVESTjfj6CpXjcw4CjQPXLhg1N+uCgc
         7DUA==
X-Forwarded-Encrypted: i=1; AFNElJ/ENFPK7wpk01r/ZnvC1lI4spsAxPoGSowjZkBwDrllhnFGPZ8aCD/hteyPuH03PsFkcA/pdM/EEzQc@vger.kernel.org
X-Gm-Message-State: AOJu0YxC0MC1yW5yHGbXD+OmEbVxwUQTZ80k/nX8li0wbYH6DPbUGscR
	ivVuOLtaF52w5Ll48J0Kydh9279DQVf6I02VMT5n1hL6tHSxvtCIYOmOgazF8R5/04KxQeppCAP
	WrsMOi8uv0udSrs2OchtKhJwmXeKYD0hu9lyW
X-Gm-Gg: AeBDieuuQCGIHzXpyfPUYmcjBhpfNBP7DiIC/IUFv2SAZNSMZtTHaeUVuVsvv6pOs/f
	0jXzdrWqWm3d1Tt7Kik535HuJ9E2MqRRt29kI3HVMW+wiAEzdCB5Wp3+3CMcJKbzBiRF4upWs3I
	2/HLwTODeMdXhExktmUsUyxlt/GKSlFiY1GWT7pXWF9KNHMLERrk55UqZ8k3vNobsywevMZzKMp
	EuaOcS0vE7ebrq0XKRnajt2xZgYooGmW+vs/tlmcXSU0y+HA32S5Z9anfdZGggpS4J6kafJuHfO
	/VuOa5dVkgtYod2NAiLV7eDxJH3YsKqqSaYwDCqtDwtfxw0U5pUs/n6y7+3e1tmBbEHjlbTnI9O
	1WfLa+esa+0XWExiS+MAfhXo5cFxjZkBmXh1xeEKPpUGJvjIQSeoTZCqL+CSf2JxFZB7+aVBbi/
	f3X8TD26iFzeBXdkun3aPWk1i4UpIhFqxSlJzDxqBmLXA=
X-Received: by 2002:a05:6214:238c:b0:8ac:a4e1:3f87 with SMTP id
 6a1803df08f44-8bc46bc1077mr61939156d6.42.1778087224619; Wed, 06 May 2026
 10:07:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
 <20260430-kerbmi-v2-1-0b98fe250425@microsoft.com> <CAGypqWyE6GF6WEj2i8LNLN2Nu=TWqO_UgUMub=OBg0x+5j6Xow@mail.gmail.com>
In-Reply-To: <CAGypqWyE6GF6WEj2i8LNLN2Nu=TWqO_UgUMub=OBg0x+5j6Xow@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 May 2026 12:06:52 -0500
X-Gm-Features: AVHnY4IZEGq7CuISZdhg-FJ7i_CcUzLnErwnErjJQvSyYKZvRAyXlM1wUveKVKw
Message-ID: <CAH2r5mtRgirBRkomM013sXEi8HKc8MSQbLZtx1Vs=Nj1NXuoeQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: Use FullSessionKey for AES-256
 encryption key derivation
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Piyush Sachdeva <s.piyush1024@gmail.com>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	samba-technical@lists.samba.org, vaibsharma@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 6, 2026 at 11:59=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> On Thu, Apr 30, 2026 at 10:50=E2=80=AFAM Piyush Sachdeva <s.piyush1024@gm=
ail.com> wrote:
> >
> > When Kerberos authentication is used with AES-256 encryption (AES-256-C=
CM
> > or AES-256-GCM), the SMB3 encryption and decryption keys must be derive=
d
> > using the full session key (Session.FullSessionKey) rather than just th=
e
> > first 16 bytes (Session.SessionKey).
> >
> > Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
> > Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionK=
ey
> > must be set to the full cryptographic key from the GSS authentication
> > context. The encryption and decryption key derivation (SMBC2SCipherKey,
> > SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
> > signing key derivation continues to use Session.SessionKey (first 16
> > bytes) in all cases.
> >
> > Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as t=
he
> > HMAC-SHA256 key input length for all derivations. When Kerberos with
> > AES-256 provides a 32-byte session key, the KDF for encryption/decrypti=
on
> > was using only the first 16 bytes, producing keys that did not match th=
e
> > server's, causing mount failures with sec=3Dkrb5 and require_gcm_256=3D=
1.
> >
> > Add a full_key_size parameter to generate_key() and pass the appropriat=
e
> > size from generate_smb3signingkey():
> >  - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
> >  - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16
> >
> > Also fix cifs_dump_full_key() to report the actual session key length f=
or
> > AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tool=
s
> > like Wireshark receive the correct key for decryption.
> >
> > Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
> > Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
> > ---
> >  fs/smb/client/ioctl.c         |  2 +-
> >  fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
> >  2 files changed, 27 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> > index 9afab3237e54..17408bb8ab65 100644
> > --- a/fs/smb/client/ioctl.c
> > +++ b/fs/smb/client/ioctl.c
> > @@ -296,7 +296,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tco=
n, struct smb3_full_key_debug
> >                 break;
> >         case SMB2_ENCRYPTION_AES256_CCM:
> >         case SMB2_ENCRYPTION_AES256_GCM:
> > -               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
> > +               out.session_key_length =3D ses->auth_key.len;
> >                 out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM256_CRYPTKEY_SIZE;
> >                 break;
> >         default:
> > diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpor=
t.c
> > index 41009039b4cb..be421b852246 100644
> > --- a/fs/smb/client/smb2transport.c
> > +++ b/fs/smb/client/smb2transport.c
> > @@ -251,7 +251,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct T=
CP_Server_Info *server)
> >  }
> >
> >  static void generate_key(struct cifs_ses *ses, struct kvec label,
> > -                        struct kvec context, __u8 *key, unsigned int k=
ey_size)
> > +                        struct kvec context, __u8 *key, unsigned int k=
ey_size,
> > +                        unsigned int full_key_size)
> >  {
> >         unsigned char zero =3D 0x0;
> >         __u8 i[4] =3D {0, 0, 0, 1};
> > @@ -265,7 +266,7 @@ static void generate_key(struct cifs_ses *ses, stru=
ct kvec label,
> >         memset(key, 0x0, key_size);
> >
> >         hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
> > -                                    SMB2_NTLMV2_SESSKEY_SIZE);
> > +                                    full_key_size);
> >         hmac_sha256_update(&hmac_ctx, i, 4);
> >         hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
> >         hmac_sha256_update(&hmac_ctx, &zero, 1);
> > @@ -298,6 +299,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server,
> >                         const struct derivation_triplet *ptriplet)
> >  {
> > +       unsigned int full_key_size =3D SMB2_NTLMV2_SESSKEY_SIZE;
> >         bool is_binding =3D false;
> >         int chan_index =3D 0;
> >
> > @@ -330,12 +332,24 @@ generate_smb3signingkey(struct cifs_ses *ses,
> >         if (is_binding) {
> >                 generate_key(ses, ptriplet->signing.label,
> >                              ptriplet->signing.context,
> > -                            ses->chans[chan_index].signkey,
> > -                            SMB3_SIGN_KEY_SIZE);
> > +                            ses->chans[chan_index].signkey, SMB3_SIGN_=
KEY_SIZE,
> > +                            SMB2_NTLMV2_SESSKEY_SIZE);
> >         } else {
> >                 generate_key(ses, ptriplet->signing.label,
> > -                            ptriplet->signing.context,
> > -                            ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
> > +                            ptriplet->signing.context, ses->smb3signin=
gkey,
> > +                            SMB3_SIGN_KEY_SIZE, SMB2_NTLMV2_SESSKEY_SI=
ZE);
> > +
> > +               /*
> > +                * Per MS-SMB2 3.2.5.3.1, signing key always uses Sessi=
on.SessionKey
> > +                * (first 16 bytes). Encryption/decryption keys use
> > +                * Session.FullSessionKey when dialect is 3.1.1 and cip=
her is
> > +                * AES-256-CCM or AES-256-GCM, otherwise Session.Sessio=
nKey.
> > +                */
> > +
> > +               if (server->dialect =3D=3D SMB311_PROT_ID &&
> > +                   (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_=
CCM ||
> > +                    server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_=
GCM))
> > +                       full_key_size =3D ses->auth_key.len;
> >
> >                 /* safe to access primary channel, since it will never =
go away */
> >                 spin_lock(&ses->chan_lock);
> > @@ -345,10 +359,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
> >
> >                 generate_key(ses, ptriplet->encryption.label,
> >                              ptriplet->encryption.context,
> > -                            ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_S=
IZE);
> > +                            ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_S=
IZE,
> > +                            full_key_size);
> > +
> >                 generate_key(ses, ptriplet->decryption.label,
> >                              ptriplet->decryption.context,
> > -                            ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_S=
IZE);
> > +                            ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_S=
IZE,
> > +                            full_key_size);
> >         }
> >
> >  #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
> > @@ -361,7 +378,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
> >                         &ses->Suid);
> >         cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
> >         cifs_dbg(VFS, "Session Key   %*ph\n",
> > -                SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
> > +                ses->auth_key.len, ses->auth_key.response);
> >         cifs_dbg(VFS, "Signing Key   %*ph\n",
> >                  SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
> >         if ((server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM) ||
> >
> > --
> Looks good to me. It should be cc: stable.
> Reviewed-by: Bharath SM <bharathsm@microsoft.com>

I had already cc: stable, but have added the RB. thx


--=20
Thanks,

Steve
