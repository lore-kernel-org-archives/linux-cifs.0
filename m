Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF63EFD28
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079163; cv=none; b=Sch7O4PS5qaZHGsK1QaU+01lD4PSCPo/ZHhq6P8FVp2Up9DTHvcMOBlpuBjNG3VJAnPCzXywWu+d8/OEDIfk2oHqauoyS9sb8GnmiL+9ppPppLjRjzgHwlDO8IHpF4H5bRjRx9wZ3LdXbsJhgcEYYHvB/C7vQVSx3dCZI1aXsoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079163; c=relaxed/simple;
	bh=k7HSqtTd+HxlYUCbP23V6WqYROzMARB6dKNqR2kdz3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nv6qJ/RY4D6GGCOsgJuCO1Z6HnxyOAo6/IdE0PIi6cKQUPSke1JTuM7cctAfWoYq4mFLVI6RuAFWU6O6H7bEtS2+l6TF4i97Srn8W5Zy2ah0Q/Ur+gG7+f1O+S4Qi7nK1kgK6QRmrOmwoU0xJUT+GbRvAokjxEEeQxmS8okUC+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yslP0flI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y9KPHF1d; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yslP0flI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y9KPHF1d; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yslP0flI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y9KPHF1d";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yslP0flI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y9KPHF1d"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1EA794D24E;
	Mon,  9 Mar 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773079160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEAOGeDD/pXfmz20S3jiOz9rD1hceR9ui9WtpDf5hAc=;
	b=yslP0flIsdZ+sIgdlGWQ7JbKEbw30V/XTjeYaFh1DL4uaML+0ErXtUljaPQMqEhHeX5P7Z
	yazErD+Ryv1ueCEHAEOINLCiwvOv29lNiYppc4xlB0rwae8E+1dG7esJHe6SJ+pfcKF2b/
	lkt91l/Q9sXofFH73orldy9KWvf1458=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773079160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEAOGeDD/pXfmz20S3jiOz9rD1hceR9ui9WtpDf5hAc=;
	b=y9KPHF1dKVQ3BNHLFtXCyTx/V4FvJKWiPetJA2bs9a2bgvXXN/cgzYnlj7Dv8Q6hW4LDzF
	3irBGIt5wx2qxICw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yslP0flI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y9KPHF1d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773079160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEAOGeDD/pXfmz20S3jiOz9rD1hceR9ui9WtpDf5hAc=;
	b=yslP0flIsdZ+sIgdlGWQ7JbKEbw30V/XTjeYaFh1DL4uaML+0ErXtUljaPQMqEhHeX5P7Z
	yazErD+Ryv1ueCEHAEOINLCiwvOv29lNiYppc4xlB0rwae8E+1dG7esJHe6SJ+pfcKF2b/
	lkt91l/Q9sXofFH73orldy9KWvf1458=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773079160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEAOGeDD/pXfmz20S3jiOz9rD1hceR9ui9WtpDf5hAc=;
	b=y9KPHF1dKVQ3BNHLFtXCyTx/V4FvJKWiPetJA2bs9a2bgvXXN/cgzYnlj7Dv8Q6hW4LDzF
	3irBGIt5wx2qxICw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C6E83F017;
	Mon,  9 Mar 2026 17:59:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sNXZGHcKr2nSJQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 09 Mar 2026 17:59:19 +0000
Date: Mon, 9 Mar 2026 14:59:17 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, linux-cifs@vger.kernel.org, 
	smfrench@gmail.com, pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
Message-ID: <e3gwcmglyhifzuugqzkez7v2gkqzcn73ial3xysfvpijf5d5gj@r5rqvx23qtgq>
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org>
 <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,vger.kernel.org,gmail.com,manguebit.com,microsoft.com,redhat.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 1EA794D24E
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On 03/09, Shyam Prasad N wrote:
>On Mon, Mar 9, 2026 at 9:49=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote:
>>
>> Hi!
>>
>> I wonder which servers are expected to be implementing this? I suppose
>> this protocol extension is not proposed without a server vendor
>> interested in actually implementing it, otherwise the whole metrics
>> story doesn't make sense.
>
>Hi Ralph,
>
>This is supposed to give the server an idea of what version of cifs.ko
>the client is actually running.

I agree with others on this point -- cifs.ko version is useless to match
to a particular behaviour or pinpoint a specific bug.

>This can be useful for servers like Azure SMB servers, where it is not
>easy to explain client side behaviour without knowing what exact
>version of the code is running on the client.

If the proposal is going to be bidirectional, it would be much better,
for cifs.ko, to have servers sending such information to clients
instead;  even when there's a problem on the server, it'll usually
reflect on the client (crashes, misbehaviour, etc).

Also useful for cases where customers don't have direct/easy access to
their SMB infrastructure (e.g. external/3rd party hosting, or 1000s of
servers mixed with DFS and/or clusters).


Cheers,

Enzo

>> *scratches head*
>>
>> Thanks!
>> -slow
>>
>> On 3/4/26 1:27 PM, nspmangalore@gmail.com wrote:
>> > From: Shyam Prasad N <sprasad@microsoft.com>
>> >
>> > MS-SMB2 does not allow any fields for the client to communicate
>> > the client version details to the server. This change is a
>> > proof-of-concept to add client details in a new negotiate context.
>> >
>> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>> > ---
>> >   fs/smb/client/smb2pdu.c | 78 +++++++++++++++++++++++++++++++++++++++=
++
>> >   fs/smb/common/smb2pdu.h | 32 +++++++++++++++++
>> >   2 files changed, 110 insertions(+)
>> >
>> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> > index ef655acf673df..9c89f6b4a6709 100644
>> > --- a/fs/smb/client/smb2pdu.c
>> > +++ b/fs/smb/client/smb2pdu.c
>> > @@ -24,6 +24,7 @@
>> >   #include <linux/pagemap.h>
>> >   #include <linux/xattr.h>
>> >   #include <linux/netfs.h>
>> > +#include <linux/utsname.h>
>> >   #include <trace/events/netfs.h>
>> >   #include "cifsglob.h"
>> >   #include "cifsproto.h"
>> > @@ -45,6 +46,7 @@
>> >   #include "cached_dir.h"
>> >   #include "compress.h"
>> >   #include "fs_context.h"
>> > +#include "cifsfs.h"
>> >
>> >   /*
>> >    *  The following table defines the expected "StructureSize" of SMB2=
 requests
>> > @@ -724,6 +726,75 @@ build_posix_ctxt(struct smb2_posix_neg_context *p=
neg_ctxt)
>> >       pneg_ctxt->Name[15] =3D 0x7C;
>> >   }
>> >
>> > +static unsigned int
>> > +build_implementation_id_ctxt(struct smb2_implementation_id_context *p=
neg_ctxt)
>> > +{
>> > +     struct nls_table *cp =3D load_nls_default();
>> > +     struct new_utsname *uts =3D utsname();
>> > +     const char *impl_domain =3D "kernel.org";
>> > +     const char *impl_name =3D "fs/smb/client";
>> > +     const char *os_name =3D "Linux";
>> > +     unsigned int data_len =3D 0;
>> > +     __u8 *data_ptr;
>> > +     int len;
>> > +
>> > +     pneg_ctxt->ContextType =3D SMB2_IMPLEMENTATION_ID_CONTEXT_ID;
>> > +     data_ptr =3D pneg_ctxt->Data;
>> > +
>> > +     /* ImplDomain */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_domain,
>> > +                           SMB2_IMPL_ID_MAX_DOMAIN_LEN, cp);
>> > +     pneg_ctxt->ImplDomainLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* ImplName */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, impl_name,
>> > +                           SMB2_IMPL_ID_MAX_NAME_LEN, cp);
>> > +     pneg_ctxt->ImplNameLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* ImplVersion - CIFS_VERSION from cifsfs.h */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, CIFS_VERSION,
>> > +                           SMB2_IMPL_ID_MAX_VERSION_LEN, cp);
>> > +     pneg_ctxt->ImplVersionLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* HostName - from utsname()->nodename */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->nodename,
>> > +                           SMB2_IMPL_ID_MAX_HOSTNAME_LEN, cp);
>> > +     pneg_ctxt->HostNameLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* OSName */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, os_name,
>> > +                           SMB2_IMPL_ID_MAX_OS_NAME_LEN, cp);
>> > +     pneg_ctxt->OSNameLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* OSVersion - from utsname()->release */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->release,
>> > +                           SMB2_IMPL_ID_MAX_OS_VERSION_LEN, cp);
>> > +     pneg_ctxt->OSVersionLength =3D cpu_to_le16(len * 2);
>> > +     data_ptr +=3D len * 2;
>> > +     data_len +=3D len * 2;
>> > +
>> > +     /* Arch - from utsname()->machine */
>> > +     len =3D cifs_strtoUTF16((__le16 *)data_ptr, uts->machine,
>> > +                           SMB2_IMPL_ID_MAX_ARCH_LEN, cp);
>> > +     pneg_ctxt->ArchLength =3D cpu_to_le16(len * 2);
>> > +     data_len +=3D len * 2;
>> > +
>> > +     pneg_ctxt->Reserved2 =3D 0;
>> > +     pneg_ctxt->DataLength =3D cpu_to_le16(data_len + 14); /* 14 =3D =
7 length fields * 2 bytes */
>> > +     /* Context size is DataLength + minimal smb2_neg_context, aligne=
d to 8 */
>> > +     return ALIGN(le16_to_cpu(pneg_ctxt->DataLength) + sizeof(struct =
smb2_neg_context), 8);
>> > +}
>> > +
>> >   static void
>> >   assemble_neg_contexts(struct smb2_negotiate_req *req,
>> >                     struct TCP_Server_Info *server, unsigned int *tota=
l_len)
>> > @@ -797,6 +868,13 @@ assemble_neg_contexts(struct smb2_negotiate_req *=
req,
>> >               neg_context_count++;
>> >       }
>> >
>> > +     /* Add implementation ID context */
>> > +     ctxt_len =3D build_implementation_id_ctxt((struct smb2_implement=
ation_id_context *)
>> > +                             pneg_ctxt);
>> > +     *total_len +=3D ctxt_len;
>> > +     pneg_ctxt +=3D ctxt_len;
>> > +     neg_context_count++;
>> > +
>> >       /* check for and add transport_capabilities and signing capabili=
ties */
>> >       req->NegotiateContextCount =3D cpu_to_le16(neg_context_count);
>> >
>> > diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
>> > index e482c86ceb00d..1ad7b57ce2952 100644
>> > --- a/fs/smb/common/smb2pdu.h
>> > +++ b/fs/smb/common/smb2pdu.h
>> > @@ -457,6 +457,7 @@ struct smb2_tree_disconnect_rsp {
>> >   #define SMB2_TRANSPORT_CAPABILITIES         cpu_to_le16(6)
>> >   #define SMB2_RDMA_TRANSFORM_CAPABILITIES    cpu_to_le16(7)
>> >   #define SMB2_SIGNING_CAPABILITIES           cpu_to_le16(8)
>> > +#define SMB2_IMPLEMENTATION_ID_CONTEXT_ID    cpu_to_le16(0xF100)
>> >   #define SMB2_POSIX_EXTENSIONS_AVAILABLE             cpu_to_le16(0x10=
0)
>> >
>> >   struct smb2_neg_context {
>> > @@ -596,6 +597,37 @@ struct smb2_signing_capabilities {
>> >       /*  Followed by padding to 8 byte boundary (required by some ser=
vers) */
>> >   } __packed;
>> >
>> > +/*
>> > + * For implementation ID context see MS-SMB2 2.2.3.1.8
>> > + * Maximum string lengths per specification
>> > + */
>> > +#define SMB2_IMPL_ID_MAX_DOMAIN_LEN  128
>> > +#define SMB2_IMPL_ID_MAX_NAME_LEN    260
>> > +#define SMB2_IMPL_ID_MAX_VERSION_LEN 260
>> > +#define SMB2_IMPL_ID_MAX_HOSTNAME_LEN        64
>> > +#define SMB2_IMPL_ID_MAX_OS_NAME_LEN 64
>> > +#define SMB2_IMPL_ID_MAX_OS_VERSION_LEN      64
>> > +#define SMB2_IMPL_ID_MAX_ARCH_LEN    64
>> > +
>> > +struct smb2_implementation_id_context {
>> > +     __le16  ContextType; /* 9 */
>> > +     __le16  DataLength;
>> > +     __le32  Reserved;
>> > +     __le16  ImplDomainLength;
>> > +     __le16  ImplNameLength;
>> > +     __le16  ImplVersionLength;
>> > +     __le16  HostNameLength;
>> > +     __le16  OSNameLength;
>> > +     __le16  OSVersionLength;
>> > +     __le16  ArchLength;
>> > +     __le16  Reserved2;
>> > +     /* Followed by variable length UTF-16 strings:
>> > +      * ImplDomain, ImplName, ImplVersion, HostName,
>> > +      * OSName, OSVersion, Arch
>> > +      */
>> > +     __u8    Data[];
>> > +} __packed;
>> > +
>> >   #define POSIX_CTXT_DATA_LEN 16
>> >   struct smb2_posix_neg_context {
>> >       __le16  ContextType; /* 0x100 */
>>
>
>
>--=20
>Regards,
>Shyam
>
