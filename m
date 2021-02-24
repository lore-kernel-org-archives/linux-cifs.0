Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A63C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 16:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 018C864F04
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 16:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhBXQ5S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbhBXQ5H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 11:57:07 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DBDC06178A;
        Wed, 24 Feb 2021 08:56:51 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id m9so2487416ybk.8;
        Wed, 24 Feb 2021 08:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4socF7afFNU9ab4f7jBoRnfISIXE3C9G3QChXhXIvIY=;
        b=UErSazcD7ugdXDVJas3urWUy+bkGns9IQcLsXpR5uFVRIJwA0hRgJigcO9RbNDvUWo
         mTXoeDd2IP3u14QP0U7IFpn+5D1D/G8rJGTv7uhcmBCK7iO7NjS/r0yiVN1LNf1gbZYF
         LL6kP46Jd3rSOlQxcO7qvDjtPnGDz1rxLIPvvOZIi9nw5Kg4D7LgmHYDs+FeUatQtYOW
         +vSAtvNqx4DIKF1V0BDmu8sJVwnOkkyChIiQ7dM/6pHcie96HWcQOAtVqOi7ugpY/ayy
         wq8B69KfwjtZwRML7suUXx8fembdYYuh4eSpCl0aUqV/cFG4h9aGOjawMA41Ro9XLGKK
         /lVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4socF7afFNU9ab4f7jBoRnfISIXE3C9G3QChXhXIvIY=;
        b=mgPmjYEJQ/DSyzaRv/M6IQ95+vIr9StqlhMGEDlu8PREMyB2cSCkfFoOEQUw91V6a4
         pceM9mKm016hHO2FMpIE0dVxkQBLJoBgIiqB7jAP5G/rmt/S62vUS/H/8WoF/kgQyiob
         N1BzQvjeIQtok8mzJqXZ7ElYbNdglm2jKN5QfdMbXfGWwPN5qan/K35tS1uppnQsf7+B
         WFElIFVIzrf+tEQU1MfZs0rt7pX2gWyItVF9xep2u9oDMwcxYKfqv/6T2G3FFBgjSQ3i
         5TE92vQKXTgm+ckB5vokp9sV+Wm7fodSEbff62oXJ1v9EESsDYfWBtj9dTmt1Tjk0uH9
         al7Q==
X-Gm-Message-State: AOAM530BWNoipSgO9oHpxlBVjY1GSoPlRWvK22zuDWwwl15nyRltYZK3
        HM3GZ5ReBdv1Pyu44kcxXCxIenT5FI+bhhkIns8=
X-Google-Smtp-Source: ABdhPJzy28YtrCuJTm3t/VrF5ALI5b6sUCG1T+wjGgUnMWwDMP800VzuS0hmC9N86RTh074Ficy/+T7XRdQgGkWLciE=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr48530494yba.3.1614185811063;
 Wed, 24 Feb 2021 08:56:51 -0800 (PST)
MIME-Version: 1.0
References: <1ca0f87e-83b3-b4dd-4448-b44f2a9d1698@canonical.com> <SG2P15301MB00639032FD6F37360A458E2D949F9@SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <SG2P15301MB00639032FD6F37360A458E2D949F9@SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 24 Feb 2021 08:56:40 -0800
Message-ID: <CANT5p=obm1EaZm+exAwjRdgrh1YV8bfMZWe-=nmwP7ExTWqX+Q@mail.gmail.com>
Subject: Re: [EXTERNAL] re: cifs: Retain old ACEs when converting between mode
 bits and ACL.
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>,
        rohiths msft <rohiths.msft@gmail.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ded7fc05bc17ebfb"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ded7fc05bc17ebfb
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

Please accept this fix for the bug that Colin pointed out.
This can be hit if the server has a corrupted SD, or it got corrupted
over the network.
We used to ignore the ACL in such a case (which in combination with my
patches caused the issue). But I think we should be returning an error
immediately.

Regards,
Shyam

On Wed, Feb 24, 2021 at 7:16 AM Shyam Prasad <Shyam.Prasad@microsoft.com> wrote:
>
> Hi Colin,
>
> Thanks for reporting this. I'll submit a fix.
>
> Regards,
> Shyam
>
> -----Original Message-----
> From: Colin Ian King <colin.king@canonical.com>
> Sent: Wednesday, February 24, 2021 6:14 PM
> To: Shyam Prasad <Shyam.Prasad@microsoft.com>
> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-kernel@vger.kernel.org
> Subject: [EXTERNAL] re: cifs: Retain old ACEs when converting between mode bits and ACL.
>
> Hi,
>
> Static analysis on linux-next with Coverity had detected a potential null pointer dereference with the following commit:
>
> commit f5065508897a922327f32223082325d10b069ebc
> Author: Shyam Prasad N <sprasad@microsoft.com>
> Date:   Fri Feb 12 04:38:43 2021 -0800
>
>     cifs: Retain old ACEs when converting between mode bits and ACL.
>
> The analysis is as follows:
>
> 1258 /* Convert permission bits from mode to equivalent CIFS ACL */
> 1259 static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
> 1260        __u32 secdesclen, __u32 *pnsecdesclen, __u64 *pnmode, kuid_t
> uid, kgid_t gid,
> 1261        bool mode_from_sid, bool id_from_sid, int *aclflag)
> 1262 {
> 1263        int rc = 0;
> 1264        __u32 dacloffset;
> 1265        __u32 ndacloffset;
> 1266        __u32 sidsoffset;
> 1267        struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> 1268        struct cifs_sid *nowner_sid_ptr = NULL, *ngroup_sid_ptr = NULL;
>
>     1. assign_zero: Assigning: dacl_ptr = NULL.
>
> 1269        struct cifs_acl *dacl_ptr = NULL;  /* no need for SACL ptr */
> 1270        struct cifs_acl *ndacl_ptr = NULL; /* no need for SACL ptr */
> 1271        char *end_of_acl = ((char *)pntsd) + secdesclen;
> 1272        u16 size = 0;
> 1273
> 1274        dacloffset = le32_to_cpu(pntsd->dacloffset);
>
>     2. Condition dacloffset, taking false branch.
>
> 1275        if (dacloffset) {
> 1276                dacl_ptr = (struct cifs_acl *)((char *)pntsd +
> dacloffset);
> 1277                if (end_of_acl < (char *)dacl_ptr +
> le16_to_cpu(dacl_ptr->size)) {
> 1278                        cifs_dbg(VFS, "Existing ACL size is wrong.
> Discarding old ACL\n");
> 1279                        dacl_ptr = NULL;
>
> NOTE: dacl_ptr is set to NULL and dacloffset is true
>
> 1280                }
> 1281        }
> 1282
> 1283        owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
> 1284                        le32_to_cpu(pntsd->osidoffset));
> 1285        group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
> 1286                        le32_to_cpu(pntsd->gsidoffset));
> 1287
>
>     3. Condition pnmode, taking true branch.
>     4. Condition *pnmode != 18446744073709551615ULL, taking false branch.
>
> 1288        if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
> 1289                ndacloffset = sizeof(struct cifs_ntsd);
> 1290                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
> ndacloffset);
> 1291                ndacl_ptr->revision =
> 1292                        dacloffset ? dacl_ptr->revision :
> cpu_to_le16(ACL_REVISION);
> 1293
> 1294                ndacl_ptr->size = cpu_to_le16(0);
> 1295                ndacl_ptr->num_aces = cpu_to_le32(0);
> 1296
> 1297                rc = set_chmod_dacl(dacl_ptr, ndacl_ptr,
> owner_sid_ptr, group_sid_ptr,
> 1298                                    pnmode, mode_from_sid);
> 1299
> 1300                sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
> 1301                /* copy the non-dacl portion of secdesc */
> 1302                *pnsecdesclen = copy_sec_desc(pntsd, pnntsd, sidsoffset,
> 1303                                NULL, NULL);
> 1304
> 1305                *aclflag |= CIFS_ACL_DACL;
> 1306        } else {
> 1307                ndacloffset = sizeof(struct cifs_ntsd);
> 1308                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
> ndacloffset);
>
>     5. Condition dacloffset, taking false branch.
>
> 1309                ndacl_ptr->revision =
> 1310                        dacloffset ? dacl_ptr->revision :
> cpu_to_le16(ACL_REVISION);
>
>     Explicit null dereferenced (FORWARD_NULL)
>
>     6. var_deref_op: Dereferencing null pointer dacl_ptr.
>
> 1311                ndacl_ptr->num_aces = dacl_ptr->num_aces;
>
>
> Line 1309..1311, when dacloffset and dacl_ptr is null we hit a null ptr dereference on dacl_ptr.
>


-- 
Regards,
Shyam

--000000000000ded7fc05bc17ebfb
Content-Type: application/octet-stream; 
	name="0001-cifs-If-a-corrupted-DACL-is-returned-by-the-server-b.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-If-a-corrupted-DACL-is-returned-by-the-server-b.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kljoaesv0>
X-Attachment-Id: f_kljoaesv0

RnJvbSBiOWY4OWExMmQ4NDVlM2I4ZmI4MDE3OWUwYzIyNWQ1ZTdlYzYzM2I1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDI0IEZlYiAyMDIxIDE1OjA0OjAyICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogSWYgYSBjb3JydXB0ZWQgREFDTCBpcyByZXR1cm5lZCBieSB0aGUgc2VydmVyLCBiYWls
CiBvdXQuCgpTdGF0aWMgY29kZSBhbmFseXNpcyByZXBvcnRlZCBhIHBvc3NpYmxlIG51bGwgcG9p
bnRlciBkZXJlZmVyZW5jZQppbiBteSBsYXN0IGNvbW1pdDoKY2lmczogUmV0YWluIG9sZCBBQ0Vz
IHdoZW4gY29udmVydGluZyBiZXR3ZWVuIG1vZGUgYml0cyBhbmQgQUNMLgoKVGhpcyBjb3VsZCBo
YXBwZW4gaWYgdGhlIERBQ0wgcmV0dXJuZWQgYnkgdGhlIHNlcnZlciBpcyBjb3JydXB0ZWQuCldl
IHdlcmUgdHJ5aW5nIHRvIGNvbnRpbnVlIGJ5IGFzc3VtaW5nIHRoYXQgdGhlIGZpbGUgaGFzIGVt
cHR5IERBQ0wuCldlIHNob3VsZCBiYWlsIG91dCB3aXRoIGFuIGVycm9yIGluc3RlYWQuCgpTaWdu
ZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpSZXBvcnRl
ZC1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4KLS0tCiBmcy9j
aWZzL2NpZnNhY2wuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNhY2wuYyBiL2ZzL2NpZnMv
Y2lmc2FjbC5jCmluZGV4IDA4MDZhZTc4NDA2MS4uOWQyOWViOTY2MGMyIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2NpZnNhY2wuYworKysgYi9mcy9jaWZzL2NpZnNhY2wuYwpAQCAtMTI3NSw4ICsxMjc1
LDggQEAgc3RhdGljIGludCBidWlsZF9zZWNfZGVzYyhzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwg
c3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLAogCWlmIChkYWNsb2Zmc2V0KSB7CiAJCWRhY2xfcHRy
ID0gKHN0cnVjdCBjaWZzX2FjbCAqKSgoY2hhciAqKXBudHNkICsgZGFjbG9mZnNldCk7CiAJCWlm
IChlbmRfb2ZfYWNsIDwgKGNoYXIgKilkYWNsX3B0ciArIGxlMTZfdG9fY3B1KGRhY2xfcHRyLT5z
aXplKSkgewotCQkJY2lmc19kYmcoVkZTLCAiRXhpc3RpbmcgQUNMIHNpemUgaXMgd3JvbmcuIERp
c2NhcmRpbmcgb2xkIEFDTFxuIik7Ci0JCQlkYWNsX3B0ciA9IE5VTEw7CisJCQljaWZzX2RiZyhW
RlMsICJTZXJ2ZXIgcmV0dXJuZWQgaWxsZWdhbCBBQ0wgc2l6ZVxuIik7CisJCQlyZXR1cm4gLUVJ
TlZBTDsKIAkJfQogCX0KIAotLSAKMi4yNS4xCgo=
--000000000000ded7fc05bc17ebfb--
