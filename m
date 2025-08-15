Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F279218AAA
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755292338; cv=none; b=UW2iNZ0b9czONmVZJHpSijn3/JzDvSz885tPF/e58P+LY+pnKcguxI/RyRsTaFYr0OK61xRcocvAyuUCViRn4Rt7H7SALXtxv6q73bQOPSA9yBwIvMFMkGjiZWXyFDN+qO7G20ssOD2ohjSCR4OwpLHlY74xheS6b9DJSA3Fmxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755292338; c=relaxed/simple;
	bh=LlllaA5Pnrr/VMYWjZLIVF98lfLC4qxwalZdhFwMgGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8hNFFrvwuN+lBEVsCfsDyHuu/h1h3Ewx/JcA/l7VwDyJ/z8uhtEcA8aKhTo+z/9RHTeC1Bo0nNu1fwQV1r9isObghI+9Q/gLoGb4iicqIzwsnzFyb+u0Xw7vx06Tg+qacgkzBDMp6cEtx8k0oBEc/9Sz0kojzZscOBgAuqxgHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/fW8I/s; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/fW8I/s"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70ba7aa13b3so10700686d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 14:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755292335; x=1755897135; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3DJoGGrFBhwvjJCwPcmRNJiUDZVY0CjWxj9AGCQt4eI=;
        b=H/fW8I/sso1zY7uxPHKXR3CRGMIiYZUcKwNTnX3pYvMzAg6/c8HJC8XcM0Y80YXcYc
         70JQmvcdCsiNAwal0um77P8xmHag20Q1bRqPR6DZfykswmMzlaQlhIw9AHzknuQFL+dK
         cnUwv7H9/EbeFl1a5TVOSvRTd6KyGHcMiImX4VqfUlOzNJh9zNbOjTvG2lG1QIBToyoz
         Y1pB3isf5QYBKWHQdeqBtRcke/NkKGR4bKfYpdaTH2yjAZaUX/RNc8ynR1ftzMRF9Emr
         M2wjoGOf3tTldHLDUbRoALjxPK53W/4LfyFWHB/f3UgRYs5Oa0Axv7+zHbAzP2EstqSb
         ThxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755292335; x=1755897135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DJoGGrFBhwvjJCwPcmRNJiUDZVY0CjWxj9AGCQt4eI=;
        b=F99i+WFfApbBgqmaVMvgh2oyZI3XMYJqIb2pwWKSL+2XSoCA+oOSBlhmdxA1ilmqTI
         Nsx/ngEkY4xE0qMfFTYfZQB+ga6mEQcQWT/+F4xa/tkn5iPgTrQvyWwdheZph3+A46XD
         tMdiucFL2tKksqvzMBnCPxvOnjOJ7Gj6/RpeytDGhlGt3d564A8U4ndq2unMZ0GFrEWf
         PlGvAGScyCUgoF+2ECPFajqvMc4sHeyzL/CgaNX/DUICfwLCVnGLWVBbScR/OEmKZmDk
         rK/a28fSLOED290oJrFkK49boDZENmjxyMg46nQzxZuNLuLikXXyxZ868c02Blg580MR
         1vbA==
X-Forwarded-Encrypted: i=1; AJvYcCUpm8/o2CIrrO6h+owxIfGxh2qfsWxJ/8W1S3lVWJUX6BV7qzrhtmWz/5paUNwJ1tcLRfdwkUn7ElVC@vger.kernel.org
X-Gm-Message-State: AOJu0YzzoN477Q72LgIKeTWPA/3K38F8NxBitu6PIxoL+2ZjxzVRmuTs
	lKv/H8MbZ7GoUcLxtwu+uHsxZRoBtDQKkvIpaSlWVq5HAfNIG8n6CYBslu1NUNuZ6LPyZZeOpFo
	X9NfHDSFwYsoP3FRVAeyx1ud1F1qmC5s=
X-Gm-Gg: ASbGncunxMqdtdaSGThbhywaX3SPbdtsX/j5jGL749s/9IjABEn+MtNUp7OwF/88pV1
	G1q8zABMV/xLsa5drdF8naXVF5MFrAM4kdalWkU51/VpRnxaN06rvv5nFunFSk830K0UuXNG/JV
	60z2gyNsUFQIpog1mNCJ2mKHpSDIupaxCm7Kr82jEhTfomc0iEi69/Sa2XJLygs2GfCHM/vLOoe
	VcnKeDmB3FtayhjLlddYSgiJyeNmbj4os2e1V3teA==
X-Google-Smtp-Source: AGHT+IFeWW8F4H1/r2bbnw+xoqhpkhJJpvyu598+Y97r9BYEdPe60r4jFePeG3o6fttD4c9SqTuL/CLbK9j92XVuNrE=
X-Received: by 2002:ad4:58e5:0:b0:70b:aff7:3548 with SMTP id
 6a1803df08f44-70baff73588mr6674066d6.22.1755292335325; Fri, 15 Aug 2025
 14:12:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812164546.29238-1-metze@samba.org> <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
 <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org> <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
 <0bcae9fe-1dff-4530-875b-fe917af5b649@samba.org> <CAH2r5mtas+irtVpkkCYRLyXpPknXqbAiN9gdupo-5z=YbFepTQ@mail.gmail.com>
 <5c1a0969-1757-46c2-ba88-a5db75f76d78@samba.org>
In-Reply-To: <5c1a0969-1757-46c2-ba88-a5db75f76d78@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Aug 2025 16:12:01 -0500
X-Gm-Features: Ac12FXx0raouwueAB8eaW5_Zv1MEWAJFFYedNi6HBNy5Q8kiXnsbsdIIakcbX3k
Message-ID: <CAH2r5mud9vmRxkxxJb6hGAJnzceVhqLo8ewqu4fOcQ3UV3nFuw@mail.gmail.com>
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()
To: Stefan Metzmacher <metze@samba.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Tom Talpey <tom@talpey.com>
Content-Type: multipart/mixed; boundary="000000000000203c3d063c6dd824"

--000000000000203c3d063c6dd824
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated ksmbd-for-next (also can see attached patch)

On Fri, Aug 15, 2025 at 1:54=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 15.08.25 um 20:52 schrieb Steve French:
> >> Maybe also remove the 'return;' from the inline ksmbd_rdma_destroy fun=
ction?
> >
> > Done (updated cifs-2.6.git for-next with attached)
> >
> > It does look a little strange that a trailing ';' is only after the
> > ksmbd_rdma_stop_listening() line - is that intentional
> >
> > diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_r=
dma.h
> > index 77aee4e5c9dc..ce3c88a45875 100644
> > --- a/fs/smb/server/transport_rdma.h
> > +++ b/fs/smb/server/transport_rdma.h
> > @@ -54,13 +54,15 @@ struct smb_direct_data_transfer {
> >
> >   #ifdef CONFIG_SMB_SERVER_SMBDIRECT
> >   int ksmbd_rdma_init(void);
> > +void ksmbd_rdma_stop_listening(void);
> >   void ksmbd_rdma_destroy(void);
> >   bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
> >   void init_smbd_max_io_size(unsigned int sz);
> >   unsigned int get_smbd_max_read_write_size(void);
> >   #else
> >   static inline int ksmbd_rdma_init(void) { return 0; }
> > -static inline int ksmbd_rdma_destroy(void) { return 0; }
> > +static inline void ksmbd_rdma_stop_listening(void) { };
> > +static inline void ksmbd_rdma_destroy(void) { }
>
> No it needs to be just { } in both cases.
>
> Thanks!
> metze
>
>


--=20
Thanks,

Steve

--000000000000203c3d063c6dd824
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Disposition: attachment; 
	filename="0001-smb-server-split-ksmbd_rdma_stop_listening-out-of-ks.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_medbpc2c0>
X-Attachment-Id: f_medbpc2c0

RnJvbSA0NzNiMWYyMGY1OTE5Y2E1OGRlZWEyZDIzZDM5Zjc1YjExYWVmODMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpE
YXRlOiBUdWUsIDEyIEF1ZyAyMDI1IDE4OjQ1OjQ2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gc21i
OiBzZXJ2ZXI6IHNwbGl0IGtzbWJkX3JkbWFfc3RvcF9saXN0ZW5pbmcoKSBvdXQgb2YKIGtzbWJk
X3JkbWFfZGVzdHJveSgpCgpXZSBjYW4ndCBjYWxsIGRlc3Ryb3lfd29ya3F1ZXVlKHNtYl9kaXJl
Y3Rfd3EpOyBiZWZvcmUgc3RvcF9zZXNzaW9ucygpIQoKT3RoZXJ3aXNlIGFscmVhZHkgZXhpc3Rp
bmcgY29ubmVjdGlvbnMgdHJ5IHRvIHVzZSBzbWJfZGlyZWN0X3dxIGFzCmEgTlVMTCBwb2ludGVy
LgoKQ2M6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+CkNjOiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPgpD
YzogbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmcKQ2M6IHNhbWJhLXRlY2huaWNhbEBsaXN0cy5z
YW1iYS5vcmcKRml4ZXM6IDA2MjZlNjY0MWY2YiAoImNpZnNkOiBhZGQgc2VydmVyIGhhbmRsZXIg
Zm9yIGNlbnRyYWwgcHJvY2Vzc2luZyBhbmQgdHJhbnBvcnQgbGF5ZXJzIikKU2lnbmVkLW9mZi1i
eTogU3RlZmFuIE1ldHptYWNoZXIgPG1ldHplQHNhbWJhLm9yZz4KQWNrZWQtYnk6IE5hbWphZSBK
ZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24uYyAg
ICAgfCAzICsrLQogZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jIHwgNSArKysrLQogZnMv
c21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5oIHwgNCArKystCiAzIGZpbGVzIGNoYW5nZWQsIDkg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2VydmVy
L2Nvbm5lY3Rpb24uYyBiL2ZzL3NtYi9zZXJ2ZXIvY29ubmVjdGlvbi5jCmluZGV4IDNmMDRhMjk3
N2JhOC4uNjdjNGY3MzM5OGRmIDEwMDY0NAotLS0gYS9mcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24u
YworKysgYi9mcy9zbWIvc2VydmVyL2Nvbm5lY3Rpb24uYwpAQCAtNTA0LDcgKzUwNCw4IEBAIHZv
aWQga3NtYmRfY29ubl90cmFuc3BvcnRfZGVzdHJveSh2b2lkKQogewogCW11dGV4X2xvY2soJmlu
aXRfbG9jayk7CiAJa3NtYmRfdGNwX2Rlc3Ryb3koKTsKLQlrc21iZF9yZG1hX2Rlc3Ryb3koKTsK
Kwlrc21iZF9yZG1hX3N0b3BfbGlzdGVuaW5nKCk7CiAJc3RvcF9zZXNzaW9ucygpOworCWtzbWJk
X3JkbWFfZGVzdHJveSgpOwogCW11dGV4X3VubG9jaygmaW5pdF9sb2NrKTsKIH0KZGlmZiAtLWdp
dCBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X3JkbWEuYyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNw
b3J0X3JkbWEuYwppbmRleCA4ZDM2NmRiNWY2MDUuLjU0NjZhYThjMzliMSAxMDA2NDQKLS0tIGEv
ZnMvc21iL3NlcnZlci90cmFuc3BvcnRfcmRtYS5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNw
b3J0X3JkbWEuYwpAQCAtMjE5NCw3ICsyMTk0LDcgQEAgaW50IGtzbWJkX3JkbWFfaW5pdCh2b2lk
KQogCXJldHVybiAwOwogfQogCi12b2lkIGtzbWJkX3JkbWFfZGVzdHJveSh2b2lkKQordm9pZCBr
c21iZF9yZG1hX3N0b3BfbGlzdGVuaW5nKHZvaWQpCiB7CiAJaWYgKCFzbWJfZGlyZWN0X2xpc3Rl
bmVyLmNtX2lkKQogCQlyZXR1cm47CkBAIC0yMjAzLDcgKzIyMDMsMTAgQEAgdm9pZCBrc21iZF9y
ZG1hX2Rlc3Ryb3kodm9pZCkKIAlyZG1hX2Rlc3Ryb3lfaWQoc21iX2RpcmVjdF9saXN0ZW5lci5j
bV9pZCk7CiAKIAlzbWJfZGlyZWN0X2xpc3RlbmVyLmNtX2lkID0gTlVMTDsKK30KIAordm9pZCBr
c21iZF9yZG1hX2Rlc3Ryb3kodm9pZCkKK3sKIAlpZiAoc21iX2RpcmVjdF93cSkgewogCQlkZXN0
cm95X3dvcmtxdWV1ZShzbWJfZGlyZWN0X3dxKTsKIAkJc21iX2RpcmVjdF93cSA9IE5VTEw7CmRp
ZmYgLS1naXQgYS9mcy9zbWIvc2VydmVyL3RyYW5zcG9ydF9yZG1hLmggYi9mcy9zbWIvc2VydmVy
L3RyYW5zcG9ydF9yZG1hLmgKaW5kZXggNzdhZWU0ZTVjOWRjLi5hMjI5MWI3NzQ4OGEgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9zZXJ2ZXIvdHJhbnNwb3J0X3JkbWEuaAorKysgYi9mcy9zbWIvc2VydmVy
L3RyYW5zcG9ydF9yZG1hLmgKQEAgLTU0LDEzICs1NCwxNSBAQCBzdHJ1Y3Qgc21iX2RpcmVjdF9k
YXRhX3RyYW5zZmVyIHsKIAogI2lmZGVmIENPTkZJR19TTUJfU0VSVkVSX1NNQkRJUkVDVAogaW50
IGtzbWJkX3JkbWFfaW5pdCh2b2lkKTsKK3ZvaWQga3NtYmRfcmRtYV9zdG9wX2xpc3RlbmluZyh2
b2lkKTsKIHZvaWQga3NtYmRfcmRtYV9kZXN0cm95KHZvaWQpOwogYm9vbCBrc21iZF9yZG1hX2Nh
cGFibGVfbmV0ZGV2KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpOwogdm9pZCBpbml0X3NtYmRf
bWF4X2lvX3NpemUodW5zaWduZWQgaW50IHN6KTsKIHVuc2lnbmVkIGludCBnZXRfc21iZF9tYXhf
cmVhZF93cml0ZV9zaXplKHZvaWQpOwogI2Vsc2UKIHN0YXRpYyBpbmxpbmUgaW50IGtzbWJkX3Jk
bWFfaW5pdCh2b2lkKSB7IHJldHVybiAwOyB9Ci1zdGF0aWMgaW5saW5lIGludCBrc21iZF9yZG1h
X2Rlc3Ryb3kodm9pZCkgeyByZXR1cm4gMDsgfQorc3RhdGljIGlubGluZSB2b2lkIGtzbWJkX3Jk
bWFfc3RvcF9saXN0ZW5pbmcodm9pZCkgeyB9CitzdGF0aWMgaW5saW5lIHZvaWQga3NtYmRfcmRt
YV9kZXN0cm95KHZvaWQpIHsgfQogc3RhdGljIGlubGluZSBib29sIGtzbWJkX3JkbWFfY2FwYWJs
ZV9uZXRkZXYoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikgeyByZXR1cm4gZmFsc2U7IH0KIHN0
YXRpYyBpbmxpbmUgdm9pZCBpbml0X3NtYmRfbWF4X2lvX3NpemUodW5zaWduZWQgaW50IHN6KSB7
IH0KIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGdldF9zbWJkX21heF9yZWFkX3dyaXRlX3Np
emUodm9pZCkgeyByZXR1cm4gMDsgfQotLSAKMi40My4wCgo=
--000000000000203c3d063c6dd824--
