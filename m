Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12586331
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351814; cv=pass; b=RrctWW1NALMA2hSg0bUPfrgYTrvaMVt80UwMDr8MUWtyNKgBGTRoZ1NtJGmZybZ7evX5SoAnC5hs7PzWUWFN1oP5IkHJUu+DpVsawWzpUhqUADV8FtA/o0qqWLdg/i2VK6+wt+P95p4ml5P7tVMz5OuJMVqtKcR1TU/fg7ER+Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351814; c=relaxed/simple;
	bh=hZyhWcT9tvtnZJUNZ7xsg+zStBv5S5R1OxDf7D4WQs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T27Nv9cdBYd2qrBqxmH+OEGyrQIXwp/WcGFhv8YiCfcgSFWAa/su8fQpVLpD3cZSmBvTakY2Jfn8r4jLsp7Xz1cwrPGSRkDGpzynuAy7mLbFX8xrRAx7qkiIiLT0xGBL9lZEZiBKJDV/NQQwOs2NqtJVEB+MI48K8IKQFK1pjf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRUQeUKZ; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRUQeUKZ"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64937edbc9eso7195829d50.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:03:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776351812; cv=none;
        d=google.com; s=arc-20240605;
        b=ZhQN2/8uINiYZmtQCJ+3jE3OcagBkpctHHKyW3cAPskAY+ak29QD0EZ3L/Qk2o0R7X
         +9vozfLh0kFjP8vDsx1BEpMf31/B0buPlwWJXxkuRpD9WUhQ22Wq8znWSVi2fyGGW2nw
         JK1Gg30VjxBXsZjfeMcJyWKmo4RFO2fBwZEVYC2hjbDDAI0BOZOzll8CUXBkAxKVceYi
         h0Ou15z3ORMSC3qe2IZTOKnI/zg2bF01e4kE/K9rTghiptqmVqieDnprVVIh4dLhRkMr
         OAUFsMWaW5NmZKZyBl2DCU3S12555+SFnDNn9cagIioGF4yPyX+k2+irFuaZ+thJGjKS
         9ZgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1zSYVnFv7uz0zbvmx0pm+7ReHBA2roaOku3B1DGvVcc=;
        fh=lkGDxTMleeT1C6iampEzcCozXL6yyr6nXHnX4y1MWrU=;
        b=dfrtxakCKv5vBx97SmOmFZA9mhuJrs0KgWbgEqmVDNSoPAIHWobbELTJiL6wiJWGoc
         OIJpoW1wcIP0gFjw42MwrVAu0ibmseSZe/K9JP9OeQm33zYW3ydZ0lx4h1p2ocv52KXe
         0bIozHh5sz+STZkARS/cI+lEQejxL2TrbmjuYdWevxlXFDb9eHCnXEtDQThRft7iZ7q2
         OnO1Wd0G+hL9u2dhWNSS6zfl0dLpFZLG7pu35aUXl35OI4xdkMetay3R/vIIFJoVzz9/
         GasK7fuhLfB9GxQm1vzk5QTKneRhos6AA8E/PgORVkdz31onzgLIJazf46y25Zi/L+AM
         uoCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776351812; x=1776956612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1zSYVnFv7uz0zbvmx0pm+7ReHBA2roaOku3B1DGvVcc=;
        b=IRUQeUKZ9d0AO8KAGIi0GaCCe7Ksz36W3PS24Hd2SQG1sExSb437y1C0lcNaK9D9kz
         t9jwrNnuLov6AGwZwReUivFHFenYWdi5a4sVhVbJjUQ9OXrxtSGM29nw9Ln+HsxgApwH
         sH2GIF4LbwBEclWz/pQAX8oOgq1fJGVMft0+f/1cAkP2Vl8UV5W5O1JsRGyPwum5fkx+
         zr9Zc5+xv56Cj2LOPn39gcRzYXJJbilz3Td7UpkocWwQGExuSPvNX14s0GpQtCViSKf0
         MKx2uQJ/8u59AOm+5Wt23OA/aM/K9tevQk9s11Gbhu/grDOxnLYkB4wTw3BdfkeeLgc4
         Ir4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351812; x=1776956612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1zSYVnFv7uz0zbvmx0pm+7ReHBA2roaOku3B1DGvVcc=;
        b=RYU5M2arjLETQtaHQWDBvmLBIMAQTOFuFfSgiwmcziecYE4TJF/BTvblcP3Jw8ec+0
         gaHtms2C1xWCmvPZMlUCBsgLbe7kPtaa/Pd+JHgEN+hz+5o9U1oCIrTHedl0iowsE6Ms
         Q4HhLwgBFige7KoVPRCD+Szqe4/CftTqkhmfSQSqzM2rlvcCXuadAFWrexF8bXkMV4g5
         hI7kvh5XU5hhsEVsQt/Q55XtvzKzcwZi9U80ULEhCP05bFIsm6DVVKGPsTp2v4BrJQbr
         WlZS0nPKxq2Yft28nDZDivAb0PRu3FBZxmdMYjtbbNLio5CqkfPRO73GBwfp0o//9XTO
         fFkQ==
X-Forwarded-Encrypted: i=1; AFNElJ8UR0cs8QWnnV4JPZ6EOpr25Ovyiu4RDisttCbEiQjswKCGU59zk9OpRdJNw79UIfkmhUe9upxBREk7@vger.kernel.org
X-Gm-Message-State: AOJu0YybUsAUfmibkD0XAATV4Nt130RVzuksDwyUBLkSLylOYV25CUUG
	DwBDvmV6lJbcegN8c1IwKSnHeO1M1++EAXXhk6i1OFYdG2WDGSk7cijGO2WaPpZGhrAnb6iQG2t
	l2qSO4Fof7WLCqBMsjYhLFcP2qULol14=
X-Gm-Gg: AeBDieutgC/iMO44o6sAz/CiIQ+iROP2LbCJO2eC1whhRWSZl1fUwrABz9dvnJN1Ehv
	gPugVmVf+Po6wZTHSvVA5lh8X+EP1eplHfJ+PQZvVPovMOb9CLu+Jo67wGbt/DzY/qRAzs6CIZx
	csCsy+Tfx9eeSwQyUXTVuWXODLIq+CTelCwHRXBmRFOkNwBpIKdKfhV0PvIVX1SOilSdTS+ePcu
	+RRx7m5mgohcpFkxfz3oxEM4U+/VxGWzDq/oS6sLRmTWGTrLPDqVHJmBjzPYwzHYurES4ItuxpZ
	Q8n8e/AWCJnd2hg=
X-Received: by 2002:a05:690e:4092:b0:652:fcd5:a30c with SMTP id
 956f58d0204a3-652fcd5a9f5mr2293646d50.60.1776351811608; Thu, 16 Apr 2026
 08:03:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409161538.3618-1-s.piyush1024@gmail.com>
In-Reply-To: <20260409161538.3618-1-s.piyush1024@gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 16 Apr 2026 15:03:19 +0000
X-Gm-Features: AQROBzClApj5L-yPN_mlNE2ZfvlUN8iDtL-Chc3BE-PVWf11tq3vtw1jkwNvS5k
Message-ID: <CAGypqWzW6YPfB2Z9nARHVj=qv8h6bcxShxxM=T1ceG9654ky8A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use FullSessionKey for AES-256 encryption
 key derivation
To: s.piyush1024@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 9:16=E2=80=AFAM <s.piyush1024@gmail.com> wrote:
>
> From: Piyush Sachdeva <psachdeva@microsoft.com>
>
> When Kerberos authentication is used with AES-256 encryption (AES-256-CCM
> or AES-256-GCM), the SMB3 encryption and decryption keys must be derived
> using the full session key (Session.FullSessionKey) rather than just the
> first 16 bytes (Session.SessionKey).
>
> Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
> Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionKey
> must be set to the full cryptographic key from the GSS authentication
> context. The encryption and decryption key derivation (SMBC2SCipherKey,
> SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
> signing key derivation continues to use Session.SessionKey (first 16
> bytes) in all cases.
>
> Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as the
> HMAC-SHA256 key input length for all derivations. When Kerberos with
> AES-256 provides a 32-byte session key, the KDF for encryption/decryption
> was using only the first 16 bytes, producing keys that did not match the
> server's, causing mount failures with sec=3Dkrb5 and require_gcm_256=3D1.
>
> Add a `full_key_size` parameter to generate_key() and pass the appropriat=
e
> size from generate_smb3signingkey():
>  - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
>  - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16
>
> Also fix cifs_dump_full_key() to report the actual session key length for
> AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tools
> like Wireshark receive the correct key for decryption.
>
> Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
> Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
> ---
>  fs/smb/client/ioctl.c         |  2 +-
>  fs/smb/client/smb2transport.c | 32 +++++++++++++++++++++++++-------
>  2 files changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index 9afab3237e54..17408bb8ab65 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -296,7 +296,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon,=
 struct smb3_full_key_debug
>                 break;
>         case SMB2_ENCRYPTION_AES256_CCM:
>         case SMB2_ENCRYPTION_AES256_GCM:
> -               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
> +               out.session_key_length =3D ses->auth_key.len;
>                 out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM256_CRYPTKEY_SIZE;
>                 break;
>         default:
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 81be2b226e26..57e515774b97 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -259,7 +259,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
>  }
>
>  static int generate_key(struct cifs_ses *ses, struct kvec label,
> -                       struct kvec context, __u8 *key, unsigned int key_=
size)
> +                       struct kvec context, __u8 *key, unsigned int key_=
size,
> +                       unsigned int full_key_size)
>  {
>         unsigned char zero =3D 0x0;
>         __u8 i[4] =3D {0, 0, 0, 1};
> @@ -280,7 +281,7 @@ static int generate_key(struct cifs_ses *ses, struct =
kvec label,
>         }
>
>         hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
> -                                    SMB2_NTLMV2_SESSKEY_SIZE);
> +                                    full_key_size);
>         hmac_sha256_update(&hmac_ctx, i, 4);
>         hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
>         hmac_sha256_update(&hmac_ctx, &zero, 1);
> @@ -315,6 +316,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                         const struct derivation_triplet *ptriplet)
>  {
>         int rc;
> +       unsigned int full_key_size;
>         bool is_binding =3D false;
>         int chan_index =3D 0;
>
> @@ -344,18 +346,32 @@ generate_smb3signingkey(struct cifs_ses *ses,
>          * master connection signing key stored in the session
>          */
>
> +       /*
> +        * Per MS-SMB2 3.2.5.3.1, signing key always uses Session.Session=
Key
> +        * (first 16 bytes). Encryption/decryption keys use
> +        * Session.FullSessionKey when dialect is 3.1.1 and cipher is
> +        * AES-256-CCM or AES-256-GCM, otherwise Session.SessionKey.
> +        */
If this change is specific to 3.1.1 should we check for version as
this looks like a common function for SMB 3.?

>         if (is_binding) {
>                 rc =3D generate_key(ses, ptriplet->signing.label,
>                                   ptriplet->signing.context,
>                                   ses->chans[chan_index].signkey,
> -                                 SMB3_SIGN_KEY_SIZE);
> +                                 SMB3_SIGN_KEY_SIZE,
> +                                 SMB2_NTLMV2_SESSKEY_SIZE);
>                 if (rc)
>                         return rc;
>         } else {
> +               if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM=
 ||
> +                   server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GCM=
)
> +                       full_key_size =3D ses->auth_key.len;
Should we validate the length passed by user space and make sure it is
within limits.?

> +               else
> +                       full_key_size =3D SMB2_NTLMV2_SESSKEY_SIZE;
Should we move the above assignment down ? As this change is
needed only for encryption and decryption and not for signing.

>                 rc =3D generate_key(ses, ptriplet->signing.label,
>                                   ptriplet->signing.context,
>                                   ses->smb3signingkey,
> -                                 SMB3_SIGN_KEY_SIZE);
> +                                 SMB3_SIGN_KEY_SIZE,
> +                                 SMB2_NTLMV2_SESSKEY_SIZE);
>                 if (rc)
>                         return rc;
>
> @@ -368,13 +384,15 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                 rc =3D generate_key(ses, ptriplet->encryption.label,
>                                   ptriplet->encryption.context,
>                                   ses->smb3encryptionkey,
> -                                 SMB3_ENC_DEC_KEY_SIZE);
> +                                 SMB3_ENC_DEC_KEY_SIZE,
> +                                 full_key_size);
>                 if (rc)
>                         return rc;
>                 rc =3D generate_key(ses, ptriplet->decryption.label,
>                                   ptriplet->decryption.context,
>                                   ses->smb3decryptionkey,
> -                                 SMB3_ENC_DEC_KEY_SIZE);
> +                                 SMB3_ENC_DEC_KEY_SIZE,
> +                                 full_key_size);
>                 if (rc)
>                         return rc;
>         }
> @@ -389,7 +407,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                         &ses->Suid);
>         cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
>         cifs_dbg(VFS, "Session Key   %*ph\n",
> -                SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
> +                ses->auth_key.len, ses->auth_key.response);
>         cifs_dbg(VFS, "Signing Key   %*ph\n",
>                  SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
>         if ((server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM) ||
> --

Other than the above comments, Patch looks good to me.
