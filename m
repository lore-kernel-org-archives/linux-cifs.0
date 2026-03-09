Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600AD392809
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074250; cv=pass; b=VQSahKe2s0leQ+HkPVxkqewVv3agq8IIINCW7LT2Gk4INfnd32gZo9HmSgDTQ5o//oqPAU5gbysnuPmkT9kvKDECrXaKFEz3CD6x++6u10iC2aWwH6Qu35gN1Il62GjH5PZVBprzR21XwP6AtNqeuTVl4Q65mB7ii6IeT5MJ8Ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074250; c=relaxed/simple;
	bh=lBOcjXEMZkn2SKUiGDgogZ+r8vmqfoaQl/pzanVQc88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qcQFdfq1PwRKtcXSyTVVbRtU4oUl7vd3JADAeHRFNnoue5T3S3z9mi9Ti0Stcpp29SFOWmR5sypayzKvUITSCZYYScWjmBj/CuRWA6IVqLiERx20nqvto3uc+8l9IF5Yn7G7iI8LIgdk1xYp9ZUR6m9CuhiH/LktVGs4xy8nn6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L4BJ3jod; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4BJ3jod"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-660dcafc85aso10139416a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 09:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773074248; cv=none;
        d=google.com; s=arc-20240605;
        b=Hr/ZrbA8qTsGWe043ItMcUqiAmDOqbIYRtnX+cwqToBKOfAK+wJu/32wJMjTfzaav8
         FkYFZ3uDccoiY5Zs5bnHnLLHLvrCk7/+yTxsQ3x94cpyYsQ2rOY3VhOcHnJFE2gdZ6GP
         TQ5UfRyk4Qyr5Snomq8nTKLjobLSoJUGZDvY6Vz95K7Ma9SQUhIkOmvEZ+DwnGg99Ko1
         NIFPudGdBi/bSqWq5VJUqCnWTPiXaDbjb/URkxWLlZQEYr5vtEqg7gnxJyvC53UmFJlO
         Gx2Y1pGY5yQZ9ERskjaLFHV2ki+93kbi1Ng/zoC76F2Oa0u8EKo1bhugVzNoPahBUYws
         YhZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vmXGxxIGnqQms97Y/RIZDQ4LS3jnZiuCZT2jSFUvzbo=;
        fh=iIHYYH5wBLswoSxYyVuj+EnCIDMzX8XRiOQ+TJRNO8M=;
        b=DlR4+Sgcj/7UogcylnDk0L0RJuyCkXw7x90VTFIAfInDbtuxLwPSPbATrqkoPtygZ7
         5YWEKbuGG38YqqMAT9bjqVkoVLDq/wErFQZB8WgkLtQWdSyIiXgj51aGiqw2kNd/ha0o
         nLoPz5cNhmRjJtNx0+enFRNw3DuQv13WV9jrKFL3yAtACokua6yWKcWaLUwwQLDLZAh0
         NuFxfFPWZPYqnVLYSuGoVHBn5U4vy4tTUzW0/GMdZGCJF/9SLhkfT8+PEgSi5+Z4UuBB
         86+P1jrrGNeYPN5DTUnkBmtKcb+0E9T++enUx7NNBNF/EwIQHqUgA9lrL2kjd5WodIXp
         cJEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773074248; x=1773679048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmXGxxIGnqQms97Y/RIZDQ4LS3jnZiuCZT2jSFUvzbo=;
        b=L4BJ3jodMiFBgncJ6OjUfXCLwgHg01IFpd47BKcynoHommsJXr+8lCq38usbkZGGdz
         vKNAkUeCcr3f6xFlYfiuE14O0eE1TZTA2lDwMT4CAb1BgBURE2SZVpmHbYI1/BiScF8d
         F6HZ8QELIRDYH+p1g/WoGUpbY4aFH7auhSqxAfCSKFg8q88RHyjjYKAGxL7bwReuRM36
         gwfYWmW9iip5Ht50lOj0AxLM4qqjQDpcwETPJheWzd+pWXGTI77dS9X18Ml9eLUjwsyM
         CAf0l+eqZQONZlSQCXCZLlgz8pQbt0VDsv2BhdLq6MeOFMIkWGVx1r9KQc1p2xK7H9yV
         N4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773074248; x=1773679048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vmXGxxIGnqQms97Y/RIZDQ4LS3jnZiuCZT2jSFUvzbo=;
        b=p2NYvV4ZOq2sgrilb4xI1z8D4UC1XznqJ0kpZiZS+C0dMCym3ibJpsO6+QLqfMEm3f
         fbIb1sJ72iUyvvWAI9yD8WslBvP0+zQpWVKl0zzgWZFRob7fpBULBCn4/pJ9rV8z2vh/
         X9hFc8lH+ISefftOdSb9lqT34vT6XElfrM/ObCPgcfU36sy74hTs4FDUkwVrVgUXG1Lg
         MRek/j6pGt2CarBDKVf3B9wuGXNK//aHU9TfajyTVUKlDiVzDBYyTPDjNjv1X1L2AkH8
         qWWtFWO3Buk3yGvOezgeEhm7NXRnygoB+ZZOulLG8UGVFNIm4TOTu31Ckz3kgem7AiGt
         mwwQ==
X-Gm-Message-State: AOJu0YyqSKB4t9fPHxObqwTTFLyxZlOlXsW33PGJfXdYyzloFMkctrBk
	6hippkjd6yBdzNsZZzaOcKND42f8mor4R7I7bZHd3/UDDZWnsu+g9HLHPDU0hRu/f9P/y0MaTw2
	yoOBMd1Kfj8areL88iqTo4FcbT594ySw=
X-Gm-Gg: ATEYQzwVYN9wFcwrscS8qh4iGjp5oKDb2ERCNwtNSJ5jsp8t8/FdlSCB+aD4LZFJ/sl
	fAeVEEvRjET/pycVms8294Lnxgkmcwvafhd0HLtxKW1vz3Ugar8J6K8awdfwe0L/iSRJ9Lv/L+W
	xl9RlWFku+qXuRh6zXlF/7GEbCsY3vCH+BUZV0Ei1JEWJBM/wBCL+pZy4BOXxeTcWuF/9PcChvh
	JaHfB+Cpwv0IeKl6rfaKfEGeeeLIqmeWewZDpUS949HlEKoeRa76BRZ/Qi6/tlV53cO72qLHmdo
	7MR7AQ==
X-Received: by 2002:a05:6402:370d:b0:662:9f5c:808d with SMTP id
 4fb4d7f45d1cf-6629f5c816dmr1349546a12.17.1773074247601; Mon, 09 Mar 2026
 09:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com> <aea738fc-e422-4671-9e0a-429988fe026a@samba.org>
In-Reply-To: <aea738fc-e422-4671-9e0a-429988fe026a@samba.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 9 Mar 2026 22:07:15 +0530
X-Gm-Features: AaiRm528KzOSDYKqAgepwAOaf6TsrZFXocJ-QMJiSRfCGibSORrHSdcf6Yo2sYA
Message-ID: <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 9:49=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote:
>
> Hi!
>
> I wonder which servers are expected to be implementing this? I suppose
> this protocol extension is not proposed without a server vendor
> interested in actually implementing it, otherwise the whole metrics
> story doesn't make sense.

Hi Ralph,

This is supposed to give the server an idea of what version of cifs.ko
the client is actually running.
This can be useful for servers like Azure SMB servers, where it is not
easy to explain client side behaviour without knowing what exact
version of the code is running on the client.

>
> *scratches head*
>
> Thanks!
> -slow
>
> On 3/4/26 1:27 PM, nspmangalore@gmail.com wrote:
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > MS-SMB2 does not allow any fields for the client to communicate
> > the client version details to the server. This change is a
> > proof-of-concept to add client details in a new negotiate context.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >   fs/smb/client/smb2pdu.c | 78 ++++++++++++++++++++++++++++++++++++++++=
+
> >   fs/smb/common/smb2pdu.h | 32 +++++++++++++++++
> >   2 files changed, 110 insertions(+)
> >
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index ef655acf673df..9c89f6b4a6709 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -24,6 +24,7 @@
> >   #include <linux/pagemap.h>
> >   #include <linux/xattr.h>
> >   #include <linux/netfs.h>
> > +#include <linux/utsname.h>
> >   #include <trace/events/netfs.h>
> >   #include "cifsglob.h"
> >   #include "cifsproto.h"
> > @@ -45,6 +46,7 @@
> >   #include "cached_dir.h"
> >   #include "compress.h"
> >   #include "fs_context.h"
> > +#include "cifsfs.h"
> >
> >   /*
> >    *  The following table defines the expected "StructureSize" of SMB2 =
requests
> > @@ -724,6 +726,75 @@ build_posix_ctxt(struct smb2_posix_neg_context *pn=
eg_ctxt)
> >       pneg_ctxt->Name[15] =3D 0x7C;
> >   }
> >
> > +static unsigned int
> > +build_implementation_id_ctxt(struct smb2_implementation_id_context *pn=
eg_ctxt)
> > +{
> > +     struct nls_table *cp =3D load_nls_default();
> > +     struct new_utsname *uts =3D utsname();
> > +     const char *impl_domain =3D "kernel.org";
> > +     const char *impl_name =3D "fs/smb/client";
> > +     const char *os_name =3D "Linux";
> > +     unsigned int data_len =3D 0;
> > +     __u8 *data_ptr;
> > +     int len;
> > +
> > +     pneg_ctxt->ContextType =3D SMB2_IMPLEMENTATION_ID_CONTEXT_ID;
> > +     data_ptr =3D pneg_ctxt->Data;
> > +
> > +     /* ImplDomain */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_domain,
> > +                           SMB2_IMPL_ID_MAX_DOMAIN_LEN, cp);
> > +     pneg_ctxt->ImplDomainLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* ImplName */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_name,
> > +                           SMB2_IMPL_ID_MAX_NAME_LEN, cp);
> > +     pneg_ctxt->ImplNameLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* ImplVersion - CIFS_VERSION from cifsfs.h */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, CIFS_VERSION,
> > +                           SMB2_IMPL_ID_MAX_VERSION_LEN, cp);
> > +     pneg_ctxt->ImplVersionLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* HostName - from utsname()->nodename */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->nodename,
> > +                           SMB2_IMPL_ID_MAX_HOSTNAME_LEN, cp);
> > +     pneg_ctxt->HostNameLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* OSName */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, os_name,
> > +                           SMB2_IMPL_ID_MAX_OS_NAME_LEN, cp);
> > +     pneg_ctxt->OSNameLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* OSVersion - from utsname()->release */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->release,
> > +                           SMB2_IMPL_ID_MAX_OS_VERSION_LEN, cp);
> > +     pneg_ctxt->OSVersionLength =3D cpu_to_le16(len * 2);
> > +     data_ptr +=3D len * 2;
> > +     data_len +=3D len * 2;
> > +
> > +     /* Arch - from utsname()->machine */
> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->machine,
> > +                           SMB2_IMPL_ID_MAX_ARCH_LEN, cp);
> > +     pneg_ctxt->ArchLength =3D cpu_to_le16(len * 2);
> > +     data_len +=3D len * 2;
> > +
> > +     pneg_ctxt->Reserved2 =3D 0;
> > +     pneg_ctxt->DataLength =3D cpu_to_le16(data_len + 14); /* 14 =3D 7=
 length fields * 2 bytes */
> > +     /* Context size is DataLength + minimal smb2_neg_context, aligned=
 to 8 */
> > +     return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct s=
mb2_neg_context), 8);
> > +}
> > +
> >   static void
> >   assemble_neg_contexts(struct smb2_negotiate_req *req,
> >                     struct TCP_Server_Info *server, unsigned int *total=
_len)
> > @@ -797,6 +868,13 @@ assemble_neg_contexts(struct smb2_negotiate_req *r=
eq,
> >               neg_context_count++;
> >       }
> >
> > +     /* Add implementation ID context */
> > +     ctxt_len =3D build_implementation_id_ctxt((struct smb2_implementa=
tion_id_context *)
> > +                             pneg_ctxt);
> > +     *total_len +=3D ctxt_len;
> > +     pneg_ctxt +=3D ctxt_len;
> > +     neg_context_count++;
> > +
> >       /* check for and add transport_capabilities and signing capabilit=
ies */
> >       req->NegotiateContextCount =3D cpu_to_le16(neg_context_count);
> >
> > diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> > index e482c86ceb00d..1ad7b57ce2952 100644
> > --- a/fs/smb/common/smb2pdu.h
> > +++ b/fs/smb/common/smb2pdu.h
> > @@ -457,6 +457,7 @@ struct smb2_tree_disconnect_rsp {
> >   #define SMB2_TRANSPORT_CAPABILITIES         cpu_to_le16(6)
> >   #define SMB2_RDMA_TRANSFORM_CAPABILITIES    cpu_to_le16(7)
> >   #define SMB2_SIGNING_CAPABILITIES           cpu_to_le16(8)
> > +#define SMB2_IMPLEMENTATION_ID_CONTEXT_ID    cpu_to_le16(0xF100)
> >   #define SMB2_POSIX_EXTENSIONS_AVAILABLE             cpu_to_le16(0x100=
)
> >
> >   struct smb2_neg_context {
> > @@ -596,6 +597,37 @@ struct smb2_signing_capabilities {
> >       /*  Followed by padding to 8 byte boundary (required by some serv=
ers) */
> >   } __packed;
> >
> > +/*
> > + * For implementation ID context see MS-SMB2 2.2.3.1.8
> > + * Maximum string lengths per specification
> > + */
> > +#define SMB2_IMPL_ID_MAX_DOMAIN_LEN  128
> > +#define SMB2_IMPL_ID_MAX_NAME_LEN    260
> > +#define SMB2_IMPL_ID_MAX_VERSION_LEN 260
> > +#define SMB2_IMPL_ID_MAX_HOSTNAME_LEN        64
> > +#define SMB2_IMPL_ID_MAX_OS_NAME_LEN 64
> > +#define SMB2_IMPL_ID_MAX_OS_VERSION_LEN      64
> > +#define SMB2_IMPL_ID_MAX_ARCH_LEN    64
> > +
> > +struct smb2_implementation_id_context {
> > +     __le16  ContextType; /* 9 */
> > +     __le16  DataLength;
> > +     __le32  Reserved;
> > +     __le16  ImplDomainLength;
> > +     __le16  ImplNameLength;
> > +     __le16  ImplVersionLength;
> > +     __le16  HostNameLength;
> > +     __le16  OSNameLength;
> > +     __le16  OSVersionLength;
> > +     __le16  ArchLength;
> > +     __le16  Reserved2;
> > +     /* Followed by variable length UTF-16 strings:
> > +      * ImplDomain, ImplName, ImplVersion, HostName,
> > +      * OSName, OSVersion, Arch
> > +      */
> > +     __u8    Data[];
> > +} __packed;
> > +
> >   #define POSIX_CTXT_DATA_LEN 16
> >   struct smb2_posix_neg_context {
> >       __le16  ContextType; /* 0x100 */
>


--=20
Regards,
Shyam
