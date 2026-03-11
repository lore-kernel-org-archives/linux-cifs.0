Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9EC2C15B2
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 23:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773273161; cv=pass; b=cLSkoK7ISzo8BxYIoAB8LQd4yVVQLsF+7yiPPvcVg2y7Jby+U/S443AAXhaRlQiZVXYgQejPQNpKO6Ghw79h0A2b1CWYI6dJ1Bhut7C1NK+lIuTFY4eyHP1FFF+CpH8I/pE3mSYdB2UW2jGurVVMRNSG5VUB32u/bMUqLPsKRU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773273161; c=relaxed/simple;
	bh=wvApmMjNvGTbf0RjUgj5az72g5qkE1vUWinYsU1t8Q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tjS91UVyX9P1IJZ0xc6BrkEROoZ8tqBi0W6/ZE4XpKmqa1Y8RVyaPh3zisc/C6+9RefL7G/IVcyyMLRhNx/jc0gbY7U3e8sJxL1Vm4tlv76QfgRXeZ7f+3/bjNJeNrNL+CJbKCIGBiKoEjhxSFdVGd/AgtU5gP7E+3cVlKjBXBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOHpuCr8; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOHpuCr8"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-661d929219bso421050a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773273158; cv=none;
        d=google.com; s=arc-20240605;
        b=FOBMRp9vYHKKJiOV78lJ7sAPGjylvAMLOL8yaG/pYB1YWysgtxv3AU1UAGxAMaZnCH
         d+wStBgc3TK4pBkTWnfN7N3sj5hYjZ7PdkEVe9YgtBzv1o1qEvxmNPo96Q4+mNSp47IQ
         cYaADbi5jpfbPfwMrSntyvyFG6DfMs/4lwpjF6JO/K3jnop6zIyQJKkPIhYI5NqYug98
         jGl928YaDR6K05qi9r77jHITbhV7aknm0cbLPqaqxNzfJ11ZXLlmHPwPjv9GaIPrIZqj
         h+j4C5djoKq+OXQj8+D/ZDmIUs5RHwCehT3mbkBJagLIWA01Rm5DZcXblv3i9iI8NlFD
         MvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e5dnLulEEXraOPmn0u/FJsHnDizrkOXARS+I2TfqSmk=;
        fh=YD8RB1ZMi0fCBIT6IAmw0lzBhTxzYAJJTje8jg8Zco4=;
        b=CoGg6LPYLGarnAkM6jkeoFO+Phc1yaThItHlUGXVAfDha6/L6r0I+d+mAMPYjzkdzV
         p6y5YWOcHlxozv0I5Pmu6bYSWg5ufBcWMUoc9AsTXe0dlS0iGbAMsTQvcz9PQ8ku7J5g
         p2z1C9WmoFDFhWM05ZKH98IcQiX5pTeN5TNIM72hH+Inx+fpjdVU+xY2/Xq37DGiIJQw
         gU1Oxp2Z4lVuuluKpIf9XwhvrUT/7CFgfcaUJXhmwG5ESbHXlMXQmY5dXj9wyPovm/FZ
         SSubldyI5J/54aCIiB76z3oReO9vft6eRHdAmGCcVCtzG4FE0tIZxaW1QAhZyuJpklkl
         dZJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773273158; x=1773877958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5dnLulEEXraOPmn0u/FJsHnDizrkOXARS+I2TfqSmk=;
        b=OOHpuCr83OKyecje3Sg/OQqh42gM6yAaBZmo3kyf5B/AumAdK1yHnHXse0LKL2b+hp
         3VTHD+U2mA2YAgc+/t1d8Ae8Swnl8k9WtnhC+MPH/bYufYsGudRdh/uwjb7hGh7jzTwn
         lDk37FRnsSq0aWeVyzyu375qGC+cxa2fGJOcWxrIkYEOFZEK1ESjEY8IvPVC2E67CQYJ
         MqOFLXvzUdhoaU5tt4hiRF76E+2IUlILWvs7eRY+L/m0+9PDphIVbHS7J9stf7DzU55J
         PrMC1bayQN6v6P0qgfE505HYLz62L//qdBOeeW5QYRxjhJOlmg1XhH1OPPzNkjPI1gNP
         uqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773273158; x=1773877958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e5dnLulEEXraOPmn0u/FJsHnDizrkOXARS+I2TfqSmk=;
        b=W1j7eH24TqGYTtvfKQo1stc/+twotCZoPPvPHxlLXeFAyt4XG82DqPs4W1rXi62lAf
         zrfPygWuHXn9hKN/4ku1vupmvJ4DutH5DS55q/HSy2UzIomFNi2nIClm0E8alqnc4Sww
         TFiobt42fPXz2Z5qqtbnaQafKS6DwW4RTyvnC1JY7WfifKvDSTau/ykFYZ/DTSYUGDmF
         zEXhMK2LJxYWn3CY6FA1NeV56v0mJtKnFE4JfNE31WaCzh9RevvgXn+l7Ap+W438fBKI
         tg1vRAdbwL6OtV8bVK6VPVyyV3VKO0HHaCWnteC3K7xVOnnbNsaga4vxoIeKtH8qYS3T
         0IOQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/gY0YD1YEfBsqPe15WJiy8JW+hVJ/Z5OGrqxeQf/DMFcyuUFkP/GIkOXdEr0qywOEAxBhOcNiRWCu@vger.kernel.org
X-Gm-Message-State: AOJu0YxCI9/FggKN8/5OBYZm8zXStgvLra88Cm+dqKhnKyDiPg18fX8s
	AoHoJzvgLRdnIwfJS7GbDRqfPjHwhech5//c0hqDs7CtvXIaYjH94PSQr4i+x9VE8iFfeMkH32L
	i+YyaoE1a7/ibKmdmsUymiHI5DjOMwvY=
X-Gm-Gg: ATEYQzwosaT8pffVeLmrN2UtA+bmAKLisq0Z6d6ffeDqkaGEivuQw7QUhy6C50V/XHy
	TDxi91UN0Ad9lxf4UMDiH0pubN1dxmL+cHinM5ESuRq7gLlftj1Uk2WPjbOhUK2RpBA9xYNKrjU
	HK+gHYU8QWM4AlehUvaKe1m9BSFnBnP5j7/yiqqkWxre7Gv7NeY2e5hsveE5Gj8W0NHT+ZqbpZV
	/nX4znylug60eIIE7aM1+z/RhCCz9w4lGni3WHTqrd9q+1IuNiTURv8sYCCw/AYgO1In7cg9avU
	LkDmMw==
X-Received: by 2002:a05:6402:3554:b0:662:86a7:17a6 with SMTP id
 4fb4d7f45d1cf-663194d63a6mr2423833a12.8.1773273157775; Wed, 11 Mar 2026
 16:52:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org> <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
 <e3gwcmglyhifzuugqzkez7v2gkqzcn73ial3xysfvpijf5d5gj@r5rqvx23qtgq>
In-Reply-To: <e3gwcmglyhifzuugqzkez7v2gkqzcn73ial3xysfvpijf5d5gj@r5rqvx23qtgq>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Mar 2026 05:22:26 +0530
X-Gm-Features: AaiRm50f8CgWNJ9YuYmyhDfwxG2jJLr219g1wN80BNnwRFkzV8dOgovlHKOGbCM
Message-ID: <CANT5p=qsOxpAAva6k9RQD3TGPku2TFQsS4bKbfZPNVs-RFWONQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Ralph Boehme <slow@samba.org>, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 11:29=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 03/09, Shyam Prasad N wrote:
> >On Mon, Mar 9, 2026 at 9:49=E2=80=AFPM Ralph Boehme <slow@samba.org> wro=
te:
> >>
> >> Hi!
> >>
> >> I wonder which servers are expected to be implementing this? I suppose
> >> this protocol extension is not proposed without a server vendor
> >> interested in actually implementing it, otherwise the whole metrics
> >> story doesn't make sense.
> >
> >Hi Ralph,
> >
> >This is supposed to give the server an idea of what version of cifs.ko
> >the client is actually running.
>
> I agree with others on this point -- cifs.ko version is useless to match
> to a particular behaviour or pinpoint a specific bug.

Acked. Can you suggest an alternative field that will make the matching eas=
ier?

>
> >This can be useful for servers like Azure SMB servers, where it is not
> >easy to explain client side behaviour without knowing what exact
> >version of the code is running on the client.
>
> If the proposal is going to be bidirectional, it would be much better,
> for cifs.ko, to have servers sending such information to clients
> instead;  even when there's a problem on the server, it'll usually
> reflect on the client (crashes, misbehaviour, etc).
>
> Also useful for cases where customers don't have direct/easy access to
> their SMB infrastructure (e.g. external/3rd party hosting, or 1000s of
> servers mixed with DFS and/or clusters).

Good point. Let me rework the draft on this.

>
>
> Cheers,
>
> Enzo
>
> >> *scratches head*
> >>
> >> Thanks!
> >> -slow
> >>
> >> On 3/4/26 1:27 PM, nspmangalore@gmail.com wrote:
> >> > From: Shyam Prasad N <sprasad@microsoft.com>
> >> >
> >> > MS-SMB2 does not allow any fields for the client to communicate
> >> > the client version details to the server. This change is a
> >> > proof-of-concept to add client details in a new negotiate context.
> >> >
> >> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >> > ---
> >> >   fs/smb/client/smb2pdu.c | 78 +++++++++++++++++++++++++++++++++++++=
++++
> >> >   fs/smb/common/smb2pdu.h | 32 +++++++++++++++++
> >> >   2 files changed, 110 insertions(+)
> >> >
> >> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> >> > index ef655acf673df..9c89f6b4a6709 100644
> >> > --- a/fs/smb/client/smb2pdu.c
> >> > +++ b/fs/smb/client/smb2pdu.c
> >> > @@ -24,6 +24,7 @@
> >> >   #include <linux/pagemap.h>
> >> >   #include <linux/xattr.h>
> >> >   #include <linux/netfs.h>
> >> > +#include <linux/utsname.h>
> >> >   #include <trace/events/netfs.h>
> >> >   #include "cifsglob.h"
> >> >   #include "cifsproto.h"
> >> > @@ -45,6 +46,7 @@
> >> >   #include "cached_dir.h"
> >> >   #include "compress.h"
> >> >   #include "fs_context.h"
> >> > +#include "cifsfs.h"
> >> >
> >> >   /*
> >> >    *  The following table defines the expected "StructureSize" of SM=
B2 requests
> >> > @@ -724,6 +726,75 @@ build_posix_ctxt(struct smb2_posix_neg_context =
*pneg_ctxt)
> >> >       pneg_ctxt->Name[15] =3D 0x7C;
> >> >   }
> >> >
> >> > +static unsigned int
> >> > +build_implementation_id_ctxt(struct smb2_implementation_id_context =
*pneg_ctxt)
> >> > +{
> >> > +     struct nls_table *cp =3D load_nls_default();
> >> > +     struct new_utsname *uts =3D utsname();
> >> > +     const char *impl_domain =3D "kernel.org";
> >> > +     const char *impl_name =3D "fs/smb/client";
> >> > +     const char *os_name =3D "Linux";
> >> > +     unsigned int data_len =3D 0;
> >> > +     __u8 *data_ptr;
> >> > +     int len;
> >> > +
> >> > +     pneg_ctxt->ContextType =3D SMB2_IMPLEMENTATION_ID_CONTEXT_ID;
> >> > +     data_ptr =3D pneg_ctxt->Data;
> >> > +
> >> > +     /* ImplDomain */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_domain,
> >> > +                           SMB2_IMPL_ID_MAX_DOMAIN_LEN, cp);
> >> > +     pneg_ctxt->ImplDomainLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* ImplName */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_name,
> >> > +                           SMB2_IMPL_ID_MAX_NAME_LEN, cp);
> >> > +     pneg_ctxt->ImplNameLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* ImplVersion - CIFS_VERSION from cifsfs.h */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, CIFS_VERSION,
> >> > +                           SMB2_IMPL_ID_MAX_VERSION_LEN, cp);
> >> > +     pneg_ctxt->ImplVersionLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* HostName - from utsname()->nodename */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->nodename,
> >> > +                           SMB2_IMPL_ID_MAX_HOSTNAME_LEN, cp);
> >> > +     pneg_ctxt->HostNameLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* OSName */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, os_name,
> >> > +                           SMB2_IMPL_ID_MAX_OS_NAME_LEN, cp);
> >> > +     pneg_ctxt->OSNameLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* OSVersion - from utsname()->release */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->release,
> >> > +                           SMB2_IMPL_ID_MAX_OS_VERSION_LEN, cp);
> >> > +     pneg_ctxt->OSVersionLength =3D cpu_to_le16(len * 2);
> >> > +     data_ptr +=3D len * 2;
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     /* Arch - from utsname()->machine */
> >> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->machine,
> >> > +                           SMB2_IMPL_ID_MAX_ARCH_LEN, cp);
> >> > +     pneg_ctxt->ArchLength =3D cpu_to_le16(len * 2);
> >> > +     data_len +=3D len * 2;
> >> > +
> >> > +     pneg_ctxt->Reserved2 =3D 0;
> >> > +     pneg_ctxt->DataLength =3D cpu_to_le16(data_len + 14); /* 14 =
=3D 7 length fields * 2 bytes */
> >> > +     /* Context size is DataLength + minimal smb2_neg_context, alig=
ned to 8 */
> >> > +     return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struc=
t smb2_neg_context), 8);
> >> > +}
> >> > +
> >> >   static void
> >> >   assemble_neg_contexts(struct smb2_negotiate_req *req,
> >> >                     struct TCP_Server_Info *server, unsigned int *to=
tal_len)
> >> > @@ -797,6 +868,13 @@ assemble_neg_contexts(struct smb2_negotiate_req=
 *req,
> >> >               neg_context_count++;
> >> >       }
> >> >
> >> > +     /* Add implementation ID context */
> >> > +     ctxt_len =3D build_implementation_id_ctxt((struct smb2_impleme=
ntation_id_context *)
> >> > +                             pneg_ctxt);
> >> > +     *total_len +=3D ctxt_len;
> >> > +     pneg_ctxt +=3D ctxt_len;
> >> > +     neg_context_count++;
> >> > +
> >> >       /* check for and add transport_capabilities and signing capabi=
lities */
> >> >       req->NegotiateContextCount =3D cpu_to_le16(neg_context_count);
> >> >
> >> > diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> >> > index e482c86ceb00d..1ad7b57ce2952 100644
> >> > --- a/fs/smb/common/smb2pdu.h
> >> > +++ b/fs/smb/common/smb2pdu.h
> >> > @@ -457,6 +457,7 @@ struct smb2_tree_disconnect_rsp {
> >> >   #define SMB2_TRANSPORT_CAPABILITIES         cpu_to_le16(6)
> >> >   #define SMB2_RDMA_TRANSFORM_CAPABILITIES    cpu_to_le16(7)
> >> >   #define SMB2_SIGNING_CAPABILITIES           cpu_to_le16(8)
> >> > +#define SMB2_IMPLEMENTATION_ID_CONTEXT_ID    cpu_to_le16(0xF100)
> >> >   #define SMB2_POSIX_EXTENSIONS_AVAILABLE             cpu_to_le16(0x=
100)
> >> >
> >> >   struct smb2_neg_context {
> >> > @@ -596,6 +597,37 @@ struct smb2_signing_capabilities {
> >> >       /*  Followed by padding to 8 byte boundary (required by some s=
ervers) */
> >> >   } __packed;
> >> >
> >> > +/*
> >> > + * For implementation ID context see MS-SMB2 2.2.3.1.8
> >> > + * Maximum string lengths per specification
> >> > + */
> >> > +#define SMB2_IMPL_ID_MAX_DOMAIN_LEN  128
> >> > +#define SMB2_IMPL_ID_MAX_NAME_LEN    260
> >> > +#define SMB2_IMPL_ID_MAX_VERSION_LEN 260
> >> > +#define SMB2_IMPL_ID_MAX_HOSTNAME_LEN        64
> >> > +#define SMB2_IMPL_ID_MAX_OS_NAME_LEN 64
> >> > +#define SMB2_IMPL_ID_MAX_OS_VERSION_LEN      64
> >> > +#define SMB2_IMPL_ID_MAX_ARCH_LEN    64
> >> > +
> >> > +struct smb2_implementation_id_context {
> >> > +     __le16  ContextType; /* 9 */
> >> > +     __le16  DataLength;
> >> > +     __le32  Reserved;
> >> > +     __le16  ImplDomainLength;
> >> > +     __le16  ImplNameLength;
> >> > +     __le16  ImplVersionLength;
> >> > +     __le16  HostNameLength;
> >> > +     __le16  OSNameLength;
> >> > +     __le16  OSVersionLength;
> >> > +     __le16  ArchLength;
> >> > +     __le16  Reserved2;
> >> > +     /* Followed by variable length UTF-16 strings:
> >> > +      * ImplDomain, ImplName, ImplVersion, HostName,
> >> > +      * OSName, OSVersion, Arch
> >> > +      */
> >> > +     __u8    Data[];
> >> > +} __packed;
> >> > +
> >> >   #define POSIX_CTXT_DATA_LEN 16
> >> >   struct smb2_posix_neg_context {
> >> >       __le16  ContextType; /* 0x100 */
> >>
> >
> >
> >--
> >Regards,
> >Shyam
> >



--=20
Regards,
Shyam
