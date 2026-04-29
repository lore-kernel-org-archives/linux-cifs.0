Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02C53A4F50
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 08:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777451685; cv=none; b=q4VcrELPlQTBvKmfpKVstrplILsGk4t8cLnPd8O1zl1YmZHY9Ye+V1Jx9Jzx34mpdLaKrepG1QQ9gruhZSvRhEDgk8LpMzw+0sufBgFyg1PwNeASlTbIKi9bbGpZA00tJ2ERyg3QlXHe4j4lrA/OnjwQZuGtGhCRRwR7q6qQfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777451685; c=relaxed/simple;
	bh=2BxllXHRUI29Rtj2KmHSh/SsqLbQkOJrSOUKabd1rLg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BAopMK35iuWwOFBLzhc6+dgDJs7w3urkeBtnfRupwuNlLou4FBVlMb9/My3DeQyEoKPnkuvIrg6jqNboUFMUuruYd29ykVCnJYebqwCbCNbkuqOWWG0QwHnoAklxBGEjA2aOfP6QBoku/rXZ48b9HY03T3qkg8l6upY67ctVl/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2H+7vTJ; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2H+7vTJ"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c795f096fa5so4837130a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 01:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777451683; x=1778056483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8JKWU7+oVtYnA2UgAwt+Mku6AWp9kXmwYjj/CQXNRjM=;
        b=l2H+7vTJ4CMdc+zir253WBGNW3daQGNXWAKYi+ML5qTud/W5Zwe16JzpB+gaYhM2AX
         LDqBT+cBHdLja5iIC47mbh+zKbNPParj91hi9vv6ixUkU8ScrS/5nGIbu8l9vJS/ZnK8
         YXrqDjruAUfBG6tvbNcuENVzCZ4a2bETurBYmKt/0KR2D2ucfc7+eXruLyEv6mROLhHU
         ua4yZRh160fkiyjIWpvafM/U+uAYS/vZHsGCldge0aITVHDBWsiV6JkvUfm7RB5EUGlN
         lB71BpEAxGFOsU8tolBD5SMJh6zHQonXluWrAEq1Fto8yXjF+oukReMOrhfwb7Vdmiky
         8e/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777451683; x=1778056483;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8JKWU7+oVtYnA2UgAwt+Mku6AWp9kXmwYjj/CQXNRjM=;
        b=lEf+IM70GExEm3W1Rkms08oqAQJqJEeq4nfsdcF7xNbV4FtqMfSeMIQjZeucolC9sf
         pjOe8BL1ZYcb8/ACh1KNZuV4dY7gT88oMtgmAWLn3zHfM8qiQGal/x8Yu8Jj2AMBQTzZ
         0+p/k1JwLucmT0rjkNC08+vDSqEZzFXKgE+HVExNFvQOnHrZvW2RLAgcugVfpgzAn5sM
         W11xM7n7NtC/WIqw0twR+bpx4uVPjVVezGlbajzz9bFuMlTwhwtTK+c4I9glzjtY3z/b
         RTbZx3OjffTWU8XQOja6ejqnGuQDCwCiW+oVbKMKQB0tqwrbMTIFRzwASg+of8Jo071P
         KZgw==
X-Forwarded-Encrypted: i=1; AFNElJ8BCryfXeD5EUmuvZvzLQlbRkxr8oFVSMi7/u4PN/YnNH/Mqa2cmjnt3YjKSz0dTkoJXf0VWJ1JgkTH@vger.kernel.org
X-Gm-Message-State: AOJu0YyACoOrFJqTuS9ivLLRuavr88xZRkc82CcoNVTKeZaki0uNb0mS
	lBnzCm9S+0Fe5ihkg5pnCI7Jz50I/j3xKTwKymYSWgI+f5VPy4spcviJ
X-Gm-Gg: AeBDiet42zWCEZfC25cgSqH9G4wfrEc3T+T2CPllbRklFYvERo1mypEsyHc+la4S2CW
	Lz+wZvb8A5rjVvPiWbCRax+vZRPthU4gkhX7+pyLJuW/FR4dOTO1tDEpDZQQpt43eC2IKFMLJLU
	DAwjMBV8THDLfRTj2kX0ogrwKfMOOps6fjZIwXXUolI4Vez2qW8zGKcsNoovQ8hgJdwITD1Q/lp
	n7vVOcbsZfZbu16eeH/X1ixEY0KwXY0qPpX2sgCgs7aXew8y1XDpdwEOf/DwfK4O67GPElnwDys
	/YYW+CpGAcNIrQiiPyjs3AchINsRIKdsYDap7XRi4O20mo5xtCN+iw/f/FvMOki4gkbc/yOx48y
	OjwIjxUO1i84UEWUwybPMZ/X0pYe0YXKVHfvACNf3NY9TbRvXarASi8JECme+aytQACxNK5bDHJ
	R7i6EHVWbz9502WxWkXSM90PTJLBKmwhMl/HSisXWMIu4rI9B+nw==
X-Received: by 2002:a05:6a20:431e:b0:39b:c4cd:d848 with SMTP id adf61e73a8af0-3a39c0c3245mr7513204637.22.1777451683124;
        Wed, 29 Apr 2026 01:34:43 -0700 (PDT)
Received: from localhost ([49.207.153.169])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fd606a079sm1299001a12.12.2026.04.29.01.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 01:34:42 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, sprasad@microsoft.com,
 bharathsm@microsoft.com, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: use FullSessionKey for AES-256 encryption
 key derivation
In-Reply-To: <CAGypqWzW6YPfB2Z9nARHVj=qv8h6bcxShxxM=T1ceG9654ky8A@mail.gmail.com>
References: <20260409161538.3618-1-s.piyush1024@gmail.com>
 <CAGypqWzW6YPfB2Z9nARHVj=qv8h6bcxShxxM=T1ceG9654ky8A@mail.gmail.com>
Date: Wed, 29 Apr 2026 14:04:39 +0530
Message-ID: <m27bpqgo68.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bharath SM <bharathsm.hsk@gmail.com> writes:

> On Thu, Apr 9, 2026 at 9:16=E2=80=AFAM <s.piyush1024@gmail.com> wrote:
>>
>> From: Piyush Sachdeva <psachdeva@microsoft.com>
>>
>> When Kerberos authentication is used with AES-256 encryption (AES-256-CCM
>> or AES-256-GCM), the SMB3 encryption and decryption keys must be derived
>> using the full session key (Session.FullSessionKey) rather than just the
>> first 16 bytes (Session.SessionKey).
>>
>> Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
>> Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionKey
>> must be set to the full cryptographic key from the GSS authentication
>> context. The encryption and decryption key derivation (SMBC2SCipherKey,
>> SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
>> signing key derivation continues to use Session.SessionKey (first 16
>> bytes) in all cases.
>>
>> Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as the
>> HMAC-SHA256 key input length for all derivations. When Kerberos with
>> AES-256 provides a 32-byte session key, the KDF for encryption/decryption
>> was using only the first 16 bytes, producing keys that did not match the
>> server's, causing mount failures with sec=3Dkrb5 and require_gcm_256=3D1.
>>
>> Add a `full_key_size` parameter to generate_key() and pass the appropria=
te
>> size from generate_smb3signingkey():
>>  - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
>>  - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16
>>
>> Also fix cifs_dump_full_key() to report the actual session key length for
>> AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tools
>> like Wireshark receive the correct key for decryption.
>>
>> Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
>> Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
>> ---
>>  fs/smb/client/ioctl.c         |  2 +-
>>  fs/smb/client/smb2transport.c | 32 +++++++++++++++++++++++++-------
>>  2 files changed, 26 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
>> index 9afab3237e54..17408bb8ab65 100644
>> --- a/fs/smb/client/ioctl.c
>> +++ b/fs/smb/client/ioctl.c
>> @@ -296,7 +296,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon=
, struct smb3_full_key_debug
>>                 break;
>>         case SMB2_ENCRYPTION_AES256_CCM:
>>         case SMB2_ENCRYPTION_AES256_GCM:
>> -               out.session_key_length =3D CIFS_SESS_KEY_SIZE;
>> +               out.session_key_length =3D ses->auth_key.len;
>>                 out.server_in_key_length =3D out.server_out_key_length =
=3D SMB3_GCM256_CRYPTKEY_SIZE;
>>                 break;
>>         default:
>> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport=
.c
>> index 81be2b226e26..57e515774b97 100644
>> --- a/fs/smb/client/smb2transport.c
>> +++ b/fs/smb/client/smb2transport.c
>> @@ -259,7 +259,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TC=
P_Server_Info *server,
>>  }
>>
>>  static int generate_key(struct cifs_ses *ses, struct kvec label,
>> -                       struct kvec context, __u8 *key, unsigned int key=
_size)
>> +                       struct kvec context, __u8 *key, unsigned int key=
_size,
>> +                       unsigned int full_key_size)
>>  {
>>         unsigned char zero =3D 0x0;
>>         __u8 i[4] =3D {0, 0, 0, 1};
>> @@ -280,7 +281,7 @@ static int generate_key(struct cifs_ses *ses, struct=
 kvec label,
>>         }
>>
>>         hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
>> -                                    SMB2_NTLMV2_SESSKEY_SIZE);
>> +                                    full_key_size);
>>         hmac_sha256_update(&hmac_ctx, i, 4);
>>         hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
>>         hmac_sha256_update(&hmac_ctx, &zero, 1);
>> @@ -315,6 +316,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>>                         const struct derivation_triplet *ptriplet)
>>  {
>>         int rc;
>> +       unsigned int full_key_size;
>>         bool is_binding =3D false;
>>         int chan_index =3D 0;
>>
>> @@ -344,18 +346,32 @@ generate_smb3signingkey(struct cifs_ses *ses,
>>          * master connection signing key stored in the session
>>          */
>>
>> +       /*
>> +        * Per MS-SMB2 3.2.5.3.1, signing key always uses Session.Sessio=
nKey
>> +        * (first 16 bytes). Encryption/decryption keys use
>> +        * Session.FullSessionKey when dialect is 3.1.1 and cipher is
>> +        * AES-256-CCM or AES-256-GCM, otherwise Session.SessionKey.
>> +        */
> If this change is specific to 3.1.1 should we check for version as
> this looks like a common function for SMB 3.?
>
>>         if (is_binding) {
>>                 rc =3D generate_key(ses, ptriplet->signing.label,
>>                                   ptriplet->signing.context,
>>                                   ses->chans[chan_index].signkey,
>> -                                 SMB3_SIGN_KEY_SIZE);
>> +                                 SMB3_SIGN_KEY_SIZE,
>> +                                 SMB2_NTLMV2_SESSKEY_SIZE);
>>                 if (rc)
>>                         return rc;
>>         } else {
>> +               if (server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CC=
M ||
>> +                   server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_GC=
M)
>> +                       full_key_size =3D ses->auth_key.len;
> Should we validate the length passed by user space and make sure it is
> within limits.?
>
>> +               else
>> +                       full_key_size =3D SMB2_NTLMV2_SESSKEY_SIZE;
> Should we move the above assignment down ? As this change is
> needed only for encryption and decryption and not for signing.
>
>>                 rc =3D generate_key(ses, ptriplet->signing.label,
>>                                   ptriplet->signing.context,
>>                                   ses->smb3signingkey,
>> -                                 SMB3_SIGN_KEY_SIZE);
>> +                                 SMB3_SIGN_KEY_SIZE,
>> +                                 SMB2_NTLMV2_SESSKEY_SIZE);
>>                 if (rc)
>>                         return rc;
>>
>> @@ -368,13 +384,15 @@ generate_smb3signingkey(struct cifs_ses *ses,
>>                 rc =3D generate_key(ses, ptriplet->encryption.label,
>>                                   ptriplet->encryption.context,
>>                                   ses->smb3encryptionkey,
>> -                                 SMB3_ENC_DEC_KEY_SIZE);
>> +                                 SMB3_ENC_DEC_KEY_SIZE,
>> +                                 full_key_size);
>>                 if (rc)
>>                         return rc;
>>                 rc =3D generate_key(ses, ptriplet->decryption.label,
>>                                   ptriplet->decryption.context,
>>                                   ses->smb3decryptionkey,
>> -                                 SMB3_ENC_DEC_KEY_SIZE);
>> +                                 SMB3_ENC_DEC_KEY_SIZE,
>> +                                 full_key_size);
>>                 if (rc)
>>                         return rc;
>>         }
>> @@ -389,7 +407,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
>>                         &ses->Suid);
>>         cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
>>         cifs_dbg(VFS, "Session Key   %*ph\n",
>> -                SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
>> +                ses->auth_key.len, ses->auth_key.response);
>>         cifs_dbg(VFS, "Signing Key   %*ph\n",
>>                  SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
>>         if ((server->cipher_type =3D=3D SMB2_ENCRYPTION_AES256_CCM) ||
>> --
>
> Other than the above comments, Patch looks good to me.

Hey Bharath,
Thanks for the comments. I will prepare a V2 with the recommended
changes, and post the updated patch.

--
Best,
Piyush
