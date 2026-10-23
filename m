Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751795;
	b=C800yusyR+9VOy/0CharluaWeFdWHcgtP92wWSB+IBFhgBivnGVs/GeuacFDcogUYjWd
	 tRlDRDyITElUzxiV2kQ/R0Upkmo6Cf1p0BpxjMgDvuOSL1vBbMAj7QeCk5cWK7EGHWEIU
	 j/iCJfWOOhmP8O+qg6Edcjuign58HXsqgEl9QDky2CQivFDS4nmnELSEB5SfKGi4+BqoW
	 dcQOoSUu3wFXR6uz12O/nWuVUTe5JsG1pwLUBeAYRbj/e1uidMQpMuEz4Ujz/rcHO+Gj0
	 XwkY/hdY0czp9+DKbGCYIUkg/26r5db7l/oPKeW/54z2rZfXk0k0QGR6NuzE7ODR7Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751795;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=FZt1QToXwFcdg5H6lqvLZEg0CO9NvabKTKe3k5i+N28=;
	b=evumLq60ZbXBzmwWy5mcWG39BoB++3dkBZpfGDvMLo74KNdDsk3gw7zn6JTQDyqqC2qc
	 kC1IAObHcm3tiK/H5l/HZc439YFw8z4phoIvfWQamWqzltfZ6XuUGMgcwcSYYjcMsdCai
	 iZrGypW1YSoy26EtfTbxi21h2K5AQuvkexqoiqGgWhi5LKri6vyWjU9braXSG8yzlcDc0
	 5Wsvgnuxb4yzP5eA2oK+HMCj3j1Tpz58QBPAEGGbXfL0nHJWjMqypk7RpcSAIZMPmE+ik
	 pVbnCXt86jmqBQ//QI5UNZlDPTT4cca44bd2FGP47LOk6U4zQ/N7Z0bUBVWQCzDiAVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+RTZW3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C64606A31D
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+RTZW3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF03D1F01825
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751793;
	bh=FZt1QToXwFcdg5H6lqvLZEg0CO9NvabKTKe3k5i+N28=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S+RTZW3sLCqZfhMvw4W2SIY+8V2ZQJ7LW7w9uJ4z7yTK1mBxOm9X6rHmNxPEs1ZhF
	 cRe0QM9Z+HZcp0B7jMP0Omj7z3RU41BggoL5sqTT9SpJNTOowPMtXPV5mXJto2i17a
	 Jb5vf5/jd9Jiov0wWCN5LS1tML6Y4LiJ2jHwmXSEud1gTcpDtoWKpgNhCArKYHQsgn
	 890K0WnrSoXrRHxDycA8s/lc/6QiOluOT+A1r5AaDIFSZ4aeKXZ/SqG87Fi/xPkj45
	 QLiNoqO9Pv6kjatqu+Fk5DbzyCowqEXjirYkHsGYQ2zn/PtA51rEnK1LXcImFrJZJO
	 vPaPMTkatF8PQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4682977f9aso87325666b.1
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 03:36:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwMCUBwkt3EgdXXum46WHZh+NbRDctRpIQ+Sa7XcA8MINz65mLFQbNKZ1QhHr8sLKKpth7qxDNxjBgu@vger.kernel.org
X-Gm-Message-State: AFq9FYLmGJGOkjmJFMvkrXtONqFDFvRz2RSdLSQ9qSc0KF4Dxl6yySph
	ZbOD0Jg4XA9TMKMwPTPNMjKoOaiyJFw6soeJxoDYn8p4g/9YLNCbZgXtRpAcrCu/9L1VA3vQBzM
	JdI35Etuzpkgx+p3hyswyY+WzpIvSTYw=
X-Received: by 2002:a17:906:9f87:b0:c2d:d9f4:2c85 with SMTP id
 a640c23a62f3a-c46a90a7712mr285008766b.41.1792751791607; Fri, 23 Oct 2026
 03:36:31 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
 <bd43bd47-688e-45ba-9fd3-e32da2bb691a@samba.org> <dec5c659-a8bd-43db-a5b4-55d78fa37db0@samba.org>
In-Reply-To: <dec5c659-a8bd-43db-a5b4-55d78fa37db0@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 23 Oct 2026 19:36:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__odzY0tuTu3mNgjmYibc3Js+zgNGYb9q0ywms7L9j+w@mail.gmail.com>
X-Gm-Features: AclHuK_PAmJmjJCvwersxjoyVb62Q_2Fhsb9WarubPye9xoeXuU-_p8BHDjqzA0
Message-ID: <CAKYAXd__odzY0tuTu3mNgjmYibc3Js+zgNGYb9q0ywms7L9j+w@mail.gmail.com>
Subject: Re: ZDI-CAN-33549: New Vulnerability Report
To: Stefan Metzmacher <metze@samba.org>
Cc: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>, 
	"security@kernel.org" <security@kernel.org>, 
	"open list:SMBDIRECT (RDMA Stream Transport with Read/Writ..." <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.org>, 
	"moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ..." <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="000000000000b5d618065e7f8d36"

--000000000000b5d618065e7f8d36
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 6:04=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 22.10.26 um 00:16 schrieb Stefan Metzmacher via samba-technical:
> > Hi HYEONTAE LEE,
> >
> > would you be able to test if this is reproducable on this branch:
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/he=
ads/for-7.5/smbdirect
> > git clone -b for-7.5/smbdirect  https://git.samba.org/metze/linux/wip.g=
it for-7.5-smbdirect
> >
> > I guess it's already fixed with that.
> >
> > Thanks!
> > metze
> >
> > Am 21.10.26 um 23:16 schrieb zdi-disclosures@trendmicro.com:
> >> ZDI-CAN-33549: Linux Kernel KSMBD SMB Direct Integer Underflow Remote =
Code Execution Vulnerability
> >>
> >> -- CVSS -----------------------------------------
> >>
> >> 9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H
> >>
> >> -- ABSTRACT -------------------------------------
> >>
> >> Trend Micro's Zero Day Initiative has identified a vulnerability affec=
ting the following products:
> >> Linux - Kernel KSMBD
> >>
> >> -- VULNERABILITY DETAILS ------------------------
> >> * Version Tested:7.3-rc3
> >> * Platform Tested:debian trixie
> >>
> >> ---
> >>
> >> ### Analysis
> >>
> >> integer underflow in smbdirect_connection_rdma_xmit()
> >> The reproduce kernel built with CONFIG_SMB_SERVER_SMBDIRECT=3Dy + CONF=
IG_RDMA_RXE=3Dy
> >> Here is the target requirement
> >> 1) RDMA device
> >> 2) writable share
> >> 3) smb direct (ubuntu only)
> >>
> >> ~~~C++
> >> int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
> >>                    void *buf, size_t buf_len,
> >>                    struct smbdirect_buffer_descriptor_v1 *desc,
> >>                    size_t desc_len,
> >>                    bool is_read)
> >> {
> >> ...
> >>     for (i =3D 0; i < desc_len / sizeof(*desc); i++) {
> >>         if (!buf_len)
> >>             break;
> >>
> >>         desc_buf_len =3D le32_to_cpu(desc[i].length);
> >>         if (!desc_buf_len)
> >>             return -EINVAL;
> >>
> >>         if (desc_buf_len > buf_len) {
> >>             desc_buf_len =3D buf_len;
> >>             desc[i].length =3D cpu_to_le32(desc_buf_len);
> >>             buf_len =3D 0;                                            =
// (1)
> >>         }
> >>
> >>         credits_needed +=3D smbdirect_connection_calc_rw_credits(sc,
> >>                                        desc_buf,
> >>                                        desc_buf_len);
> >>         desc_buf +=3D desc_buf_len;
> >>         buf_len -=3D desc_buf_len;                                    =
// (2) integer underflow, and leads to heap overflow within rxe_mr_copy()
> >>         desc_num++;
> >>     }
>
> As far as I can see the problem is solved in by patches,
> but we should have a simple fix first.
>
> I think removing ' buf_len =3D 0;' should be enough for a quick fix,
> then 'buf_len -=3D desc_buf_len;' will result in buf_len =3D=3D 0 and the=
 next
> iteration will break with if (!buf_len).
>
> Namjae, do you agree? Can you create such a quick fix?
Agreed, Please check the attached patch.
Thanks for checking this issue!

--000000000000b5d618065e7f8d36
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-smbdirect-fix-buffer-length-underflow-in-RDMA-tr.patch"
Content-Disposition: attachment; 
	filename="0001-smb-smbdirect-fix-buffer-length-underflow-in-RDMA-tr.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mvku395v0>
X-Attachment-Id: f_mvku395v0

RnJvbSA1YjhjZTJlNTY3MGViZTMxOTcwYjY3MTg0MDMxOTdhZTUxZDQ3ZTQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBGcmksIDIzIE9jdCAyMDI2IDE5OjI2OjA5ICswOTAwClN1YmplY3Q6IFtQQVRDSF0gc21i
OiBzbWJkaXJlY3Q6IGZpeCBidWZmZXIgbGVuZ3RoIHVuZGVyZmxvdyBpbiBSRE1BIHRyYW5zZmVy
cwpGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgoKV2hlbiBhIHJlbW90
ZSBidWZmZXIgZGVzY3JpcHRvciBpcyBsYXJnZXIgdGhhbiB0aGUgcmVtYWluaW5nIGxvY2FsCmJ1
ZmZlciwgc21iZGlyZWN0X2Nvbm5lY3Rpb25fcmRtYV94bWl0KCkgY2xhbXBzIGl0cyBsZW5ndGgg
YW5kIHNldHMKYnVmX2xlbiB0byB6ZXJvLiBUaGUgY29tbW9uIGFjY291bnRpbmcgY29kZSB0aGVu
IHN1YnRyYWN0cyB0aGUgY2xhbXBlZApsZW5ndGggZnJvbSBidWZfbGVuLCBjYXVzaW5nIGl0IHRv
IHVuZGVyZmxvdy4gSWYgYW5vdGhlciBkZXNjcmlwdG9yCmZvbGxvd3MsIHRoZSBsb29wIHByb2Nl
c3NlcyBpdCB3aXRoIGEgd3JhcHBlZCByZW1haW5pbmcgbGVuZ3RoIGFuZAppbmNsdWRlcyBtZW1v
cnkgYmV5b25kIHRoZSBsb2NhbCBidWZmZXIgaW4gdGhlIFJETUEgdHJhbnNmZXIuCgpBIGNsaWVu
dCBjYW4gdHJpZ2dlciBhbiBvdXQtb2YtYm91bmRzIGtlcm5lbCB3cml0ZSB3aXRoIGFuIFNNQiBX
UklURQpyZXF1ZXN0LCBvciBhbiBvdXQtb2YtYm91bmRzIGtlcm5lbCByZWFkIHdpdGggYW4gU01C
IFJFQUQgcmVxdWVzdCwgYnkKc3VwcGx5aW5nIG11bHRpcGxlIFJETUEgYnVmZmVyIGRlc2NyaXB0
b3JzIHdpdGggYW4gb3ZlcnNpemVkIGRlc2NyaXB0b3IKYmVmb3JlIHRoZSBsYXN0IG9uZS4KClJl
bW92ZSB0aGUgcHJlbWF0dXJlIGFzc2lnbm1lbnQgdG8gYnVmX2xlbi4gU3VidHJhY3RpbmcgdGhl
IGNsYW1wZWQgbGVuZ3RoCmFscmVhZHkgY29uc3VtZXMgdGhlIHJlbWFpbmluZyBidWZmZXIsIHNv
IHRoZSBuZXh0IGl0ZXJhdGlvbiBzdG9wcyBhbmQKb25seSBkZXNjcmlwdG9ycyB3aXRoaW4gdGhl
IGxvY2FsIGJ1ZmZlciBhcmUgdXNlZCB0byBidWlsZCB3b3JrIHJlcXVlc3RzLgoKRml4ZXM6IGU2
MjhiZjkzOWFhZiAoImtzbWJkOiByZWR1Y2UgZGVzY3JpcHRvciBzaXplIGlmIHJlbWFpbmluZyBi
eXRlcyBpcyBsZXNzIHRoYW4gcmVxdWVzdCBzaXplIikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcKU2lnbmVkLW9mZi1ieTogU3RlZmFuIE1ldHptYWNoZXIgPG1ldHplQHNhbWJhLm9yZz4KU2ln
bmVkLW9mZi1ieTogTmFtamFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4KLS0tCiBmcy9z
bWIvc21iZGlyZWN0L3J3LmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvc21iL3NtYmRpcmVjdC9ydy5jIGIvZnMvc21iL3NtYmRpcmVjdC9ydy5j
CmluZGV4IDZmZTM4MDQyY2ZiOS4uY2IxNDJjM2M1MGIyIDEwMDY0NAotLS0gYS9mcy9zbWIvc21i
ZGlyZWN0L3J3LmMKKysrIGIvZnMvc21iL3NtYmRpcmVjdC9ydy5jCkBAIC0xNDMsNyArMTQzLDYg
QEAgaW50IHNtYmRpcmVjdF9jb25uZWN0aW9uX3JkbWFfeG1pdChzdHJ1Y3Qgc21iZGlyZWN0X3Nv
Y2tldCAqc2MsCiAJCWlmIChkZXNjX2J1Zl9sZW4gPiBidWZfbGVuKSB7CiAJCQlkZXNjX2J1Zl9s
ZW4gPSBidWZfbGVuOwogCQkJZGVzY1tpXS5sZW5ndGggPSBjcHVfdG9fbGUzMihkZXNjX2J1Zl9s
ZW4pOwotCQkJYnVmX2xlbiA9IDA7CiAJCX0KIAogCQljcmVkaXRzX25lZWRlZCArPSBzbWJkaXJl
Y3RfY29ubmVjdGlvbl9jYWxjX3J3X2NyZWRpdHMoc2MsCi0tIAoyLjI1LjEKCg==
--000000000000b5d618065e7f8d36--
