Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F981A38EC
	for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710440092; cv=none; b=jLVrR+uAhXcmpVEOtiSl58YrkZu7VJtXLvnXCcqHMrLDu9FI2P4It0WqHxEVroZoJNv1hXMxOMpzdWcuvORFo1iG/RC5WtyaWXM3cEz6toR7EwcpBJR2y+IsWAH7iIutkDFZzni3mRyjNqx90f6Z9huAKsMkFrBMZ/ep68zYK30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710440092; c=relaxed/simple;
	bh=asHZtgjoDYbab099bWBBkQlTy2yfk+LLzCLZV4EdIKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5m98Jh3ivS8rPnvuHny+3FOhCTtVsKjlP6cmFkegEe5qVOz1Yvk90aZxSCsxyP/IexdCVu9My8z3Uwc7BmHZabA6vjKHABWccy+t9MDmMOsWil72BuB38t6LFzW8J1cAX6nuul85yILG0uRQmNuIAxsOTy8xXBIlbA2N5BzAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDl4BgP5; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDl4BgP5"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dd14d8e7026so1110561276.2
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710440090; x=1711044890; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Chh9vmxVe3V0d/LrbnqQnwrcKDDdwIPuxFJw5BJoeEY=;
        b=mDl4BgP5m358vCQsFm3FH5psRJ1M65HSExC/4tBfMe/UFD/LopV4GETCpVZ0h3YIgf
         YrczVpVwnB+T74FxqFAJh6Mx1MFw6Y8I6YAvzW/piprBHm/EnPib7J6hFMa8COvSjgkY
         oUSjncxRVaYCUe5u5n0xqUVPrq3Lk8va5cKeiBswjqXjUiTLlHoR3zuoZgUQEKsHSPs2
         haEHCYrre8oi1wNwVY6h+1OSobLIP1MY1V2A6ugRWxaXV110xeTHCPWe1vvQYdy5M0Cl
         vJr628+VQRTbfxASuxX7zKTfBz+Wr9b1lUytFCrgY8xT8w+tF+X8ioPypqn3t2AyjVZT
         Wyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710440090; x=1711044890;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Chh9vmxVe3V0d/LrbnqQnwrcKDDdwIPuxFJw5BJoeEY=;
        b=w7Mynhu7xpcaLxSW6vxninVwKDFCXtVxR70OK+fSkFedQlsFqAqhG4rwmQiFy/DSNH
         MhME9H3LhnFF+umf/m5tp/vQP81r0KXjqHjUScb6Y/ozkI7DvctwuBLVNjIBmfJND+2G
         1Ns8ozVGN7WEF0ffk32AI+1BbKNLOOMsSPxsmGA0nli7fTyOXCz1x67DzYuQCOHlK+vx
         OQejKIZobTP5HDV69+dzluPEirZNoiIQ0KOBojCFfaNDnwE0xInUsv+Ftt8BJ9DxNkTQ
         eg71Fv1U1ugEaEhXru0i1MbX3W4HuNNe1eQGy8DH5ye/rxp584F76iaWYES5MU86WRwE
         lsLw==
X-Gm-Message-State: AOJu0Yy+cTvTukijtNPiWKKO0O5vo8G1FUIGeLppp9RJAdj1yR7eHUC5
	8hZNR/HHyVLHJ81KIWktYGpLmG4ToU6XV3uHUcXJJEO79YGs0V6JarF90lKxyu+Xbvx40oGJsHD
	YkVnSLLLadX+HGePHkBW9w/PfASC0rR3Y
X-Google-Smtp-Source: AGHT+IF0u/MaQLkn6B2fu5azwyvIp2l8D1k+dpc2HL3VGKOR8oxSW/peZa7acGMC4MekpTjcA3HKqCVB4W3n9Xejlyo=
X-Received: by 2002:a25:8447:0:b0:dcd:3663:b5e5 with SMTP id
 r7-20020a258447000000b00dcd3663b5e5mr2314357ybm.25.1710440089941; Thu, 14 Mar
 2024 11:14:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313150034.165152-1-bharathsm@microsoft.com> <CAH2r5mvu3Rwbv=b86MwOTYv5W4U4x7+OpM2DMCfwEvyvAEYsEg@mail.gmail.com>
In-Reply-To: <CAH2r5mvu3Rwbv=b86MwOTYv5W4U4x7+OpM2DMCfwEvyvAEYsEg@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 14 Mar 2024 23:44:38 +0530
Message-ID: <CAGypqWx3T1AXufg+KrTfhTQeZsRR7ON2jtep7c11R8N_1t=jTA@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove redundant variable assignment
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: multipart/mixed; boundary="000000000000f91c3b0613a2ddf3"

--000000000000f91c3b0613a2ddf3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for pointing it out. Updated patch.

On Thu, Mar 14, 2024 at 8:19=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> The second change in this looks a few lines off (didn't you mean to
> remove the rc =3D 0 nine lines earlier, ie the one from the EREMOTE not
> the EINVAL calse?).  See below:
>
>         case -EREMOTE:
>                 cifs_create_junction_fattr(&fattr, inode->i_sb);
>                 rc =3D 0;   /* FIX: shouldn't you remove this one */
>                 break;
>         case -EOPNOTSUPP:
>         case -EINVAL:
>                 /*
>                  * FIXME: legacy server -- fall back to path-based call?
>                  * for now, just skip revalidating and mark inode for
>                  * immediate reval.
>                  */
> -               rc =3D 0;   /* FIX: and not remove this one ? */
>                 CIFS_I(inode)->time =3D 0;
>                 goto cgfi_exit;
>         default:
>                 goto cgfi_exit;
>         }
>
>         /*
>          * don't bother with SFU junk here -- just mark inode as needing
>          * revalidation.
>          */
>         fattr.cf_uniqueid =3D CIFS_I(inode)->uniqueid;
>         fattr.cf_flags |=3D CIFS_FATTR_NEED_REVAL;
>         /* if filetype is different, return error */
>         rc =3D cifs_fattr_to_inode(inode, &fattr, false);
>
>
> On Wed, Mar 13, 2024 at 10:01=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > This removes an unnecessary variable assignment. The assigned
> > value will be overwritten by cifs_fattr_to_inode before it
> > is accessed, making the line redundant.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/inode.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index 00aae4515a09..50e939234a8e 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -400,7 +400,6 @@ cifs_get_file_info_unix(struct file *filp)
> >                 cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
> >         } else if (rc =3D=3D -EREMOTE) {
> >                 cifs_create_junction_fattr(&fattr, inode->i_sb);
> > -               rc =3D 0;
> >         } else
> >                 goto cifs_gfiunix_out;
> >
> > @@ -852,7 +851,6 @@ cifs_get_file_info(struct file *filp)
> >                  * for now, just skip revalidating and mark inode for
> >                  * immediate reval.
> >                  */
> > -               rc =3D 0;
> >                 CIFS_I(inode)->time =3D 0;
> >                 goto cgfi_exit;
> >         default:
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve

--000000000000f91c3b0613a2ddf3
Content-Type: application/octet-stream; 
	name="0001-cifs-remove-redundant-variable-assignment.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-redundant-variable-assignment.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ltrjs7xp0>
X-Attachment-Id: f_ltrjs7xp0

RnJvbSBhOWZmOTZlNmExNDk1MTI5YWFiMGJiMDgzMjVmNTgwNGMwMzBlYjZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAxNCBNYXIgMjAyNCAyMzozNjozNiArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IHJlbW92ZSByZWR1bmRhbnQgdmFyaWFibGUgYXNzaWdubWVudAoKVGhpcyByZW1vdmVzIGFu
IHVubmVjZXNzYXJ5IHZhcmlhYmxlIGFzc2lnbm1lbnQuIFRoZSBhc3NpZ25lZAp2YWx1ZSB3aWxs
IGJlIG92ZXJ3cml0dGVuIGJ5IGNpZnNfZmF0dHJfdG9faW5vZGUgYmVmb3JlIGl0CmlzIGFjY2Vz
c2VkLCBtYWtpbmcgdGhlIGxpbmUgcmVkdW5kYW50LgoKU2lnbmVkLW9mZi1ieTogQmhhcmF0aCBT
TSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5jIHwg
MiAtLQogMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21i
L2NsaWVudC9pbm9kZS5jIGIvZnMvc21iL2NsaWVudC9pbm9kZS5jCmluZGV4IDYwOTI3MjliZjdm
Ni4uZDI4YWIwYWY2MDQ5IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2lub2RlLmMKKysrIGIv
ZnMvc21iL2NsaWVudC9pbm9kZS5jCkBAIC00MDEsNyArNDAxLDYgQEAgY2lmc19nZXRfZmlsZV9p
bmZvX3VuaXgoc3RydWN0IGZpbGUgKmZpbHApCiAJCWNpZnNfdW5peF9iYXNpY190b19mYXR0cigm
ZmF0dHIsICZmaW5kX2RhdGEsIGNpZnNfc2IpOwogCX0gZWxzZSBpZiAocmMgPT0gLUVSRU1PVEUp
IHsKIAkJY2lmc19jcmVhdGVfanVuY3Rpb25fZmF0dHIoJmZhdHRyLCBpbm9kZS0+aV9zYik7Ci0J
CXJjID0gMDsKIAl9IGVsc2UKIAkJZ290byBjaWZzX2dmaXVuaXhfb3V0OwogCkBAIC04NDYsNyAr
ODQ1LDYgQEAgY2lmc19nZXRfZmlsZV9pbmZvKHN0cnVjdCBmaWxlICpmaWxwKQogCQlicmVhazsK
IAljYXNlIC1FUkVNT1RFOgogCQljaWZzX2NyZWF0ZV9qdW5jdGlvbl9mYXR0cigmZmF0dHIsIGlu
b2RlLT5pX3NiKTsKLQkJcmMgPSAwOwogCQlicmVhazsKIAljYXNlIC1FT1BOT1RTVVBQOgogCWNh
c2UgLUVJTlZBTDoKLS0gCjIuMzQuMQoK
--000000000000f91c3b0613a2ddf3--
