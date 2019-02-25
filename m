Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE8BC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 00:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCCE21019
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 00:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFoD/48/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfBYAB0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Feb 2019 19:01:26 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:41569 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfBYABZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Feb 2019 19:01:25 -0500
Received: by mail-pl1-f172.google.com with SMTP id y5so3597014plk.8
        for <linux-cifs@vger.kernel.org>; Sun, 24 Feb 2019 16:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UFH4CZna5VEcnT0jn035Clm5KqtF1n9BuzudZFBnGWc=;
        b=CFoD/48/yv9s7y7tLYxoTxoJTY10OS7RKg/lhgvMYMMuEgzNe0OhEMn+lfgkkb8jPw
         PU5l9DQInb5APySWOxqGbS+6v0JpUEuvqmh+AH91zLwYXXM+2ld0uXhPFs0vswoz0ftC
         EJTjiIjPGlKo74qjjb2TIPnfYXPkiV9RMVLa+cCruija1rXTOphe8jpnbQD0RJC6kajr
         AjOwhQkE+9hwzyyNkhzyKNs7fWckg9QA3B9lQcl+bpfY9jOisRrFSD83b4idGZfQMAwy
         krgQuGMf4gt0sOIhuoAU5qGjb4gI/Cxvj7FYXYqfXkK7l0kDvsCJTqYhbSJxlqsUlf64
         k4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UFH4CZna5VEcnT0jn035Clm5KqtF1n9BuzudZFBnGWc=;
        b=pG46hXf8yttIfcj8rwOo5EYFHMUqKTOMa1No/Xbam4yzAg8fI3MRfosOC4lxz8gTrd
         arJV74XbLkCIyg45tGln9P8VqfMgFk5ParmtullbHn1dDW9EVsQsY4Btsyv97tt25Eao
         7LgeQUZtbBR2RXGoq8RO8HHHccwzZZc/bvmj1jn4nKzMcOXZynLdGewDB/TKBOEK91ZV
         pksYFHXLr1lX+FwirhayOZjPccZGIJzsuA2vYOhaSqwGG2csgQ9zDMtcgUc/GX0eTyd+
         7hEAJZ8FZJkyk5u7FepUJHNorqdiLkg/OOjU8E7yHC2/OL6kkUxSf6cZC0eWbJpcckwj
         hwxA==
X-Gm-Message-State: AHQUAuaZYudbFlPndvkgaSHAtnd7RPoauMHB5FP6FZZfNEwxn2Aqs0Yh
        iTOz6zGSNF20LOinuJ+jSCQ2biKcBgpBR/CMdL8=
X-Google-Smtp-Source: AHgI3IYI68ttMU/g8n73K0xIBSOgmF/QXwYpWlEUh4sZDhVmj2TiXMH7aqG9/35xA4oUDItNdLXr60WTvIiA8TBZzx4=
X-Received: by 2002:a17:902:e090:: with SMTP id cb16mr16403013plb.32.1551052884726;
 Sun, 24 Feb 2019 16:01:24 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 24 Feb 2019 18:01:12 -0600
Message-ID: <CAH2r5msoRSXFj=SM54Dg7A74yMj9X1XB=S8JY1zM=FgH13qzog@mail.gmail.com>
Subject: Update POSIX negotiate context during negprot to include GUID
To:     Jeremy Allison <jra@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000038f6d80582aca4c0"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000038f6d80582aca4c0
Content-Type: text/plain; charset="UTF-8"

As requested - updated the POSIX negotiate context to include the GUID
of the only supported POSIX open/create context.

Let me know if any objections..

Tested with JRAs tree and worked fine, other than unrelated problem
(appears to be in server code) where the world writeable bit is always
masked off on mkdir (could be user error but smb.conf looked ok to me
and worked with his older tree for all modes).  Other modes (other
than setuid/setgid/sticky) work fine on directory create.

-- 
Thanks,

Steve

--00000000000038f6d80582aca4c0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Update-POSIX-negotiate-context-with-POSIX-ctxt-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Update-POSIX-negotiate-context-with-POSIX-ctxt-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsjkrlpx0>
X-Attachment-Id: f_jsjkrlpx0

RnJvbSA1NmIzMjUyMWQ1MzhlYjFmNGFkOWFhYjE1ZTEwNTUyY2FiMTliZGNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjQgRmViIDIwMTkgMTc6NTY6MzMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBVcGRhdGUgUE9TSVggbmVnb3RpYXRlIGNvbnRleHQgd2l0aCBQT1NJWCBjdHh0IEdVSUQK
ClBPU0lYIG5lZ290aWF0ZSBjb250ZXh0IG5vdyBpbmNsdWRlcyB0aGUgR1VJRCBzcGVjaWZ5aW5n
CndoaWNoIFBPU0lYIG9wZW4gY29udGV4dCB3ZSBzdXBwb3J0LgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5j
IHwgMTcgKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvc21iMnBkdS5oIHwgIDQgKystLQogMiBm
aWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNDljMjg0M2Ix
YmNmLi42NGUxNzI2MzNiYzQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2Zz
L2NpZnMvc21iMnBkdS5jCkBAIC00OTAsNiArNDkwLDIzIEBAIGJ1aWxkX3Bvc2l4X2N0eHQoc3Ry
dWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQgKnBuZWdfY3R4dCkKIHsKIAlwbmVnX2N0eHQtPkNv
bnRleHRUeXBlID0gU01CMl9QT1NJWF9FWFRFTlNJT05TX0FWQUlMQUJMRTsKIAlwbmVnX2N0eHQt
PkRhdGFMZW5ndGggPSBjcHVfdG9fbGUxNihQT1NJWF9DVFhUX0RBVEFfTEVOKTsKKwkvKiBTTUIy
X0NSRUFURV9UQUdfUE9TSVggaXMgIjB4OTNBRDI1NTA5Q0I0MTFFN0I0MjM4M0RFOTY4QkNEN0Mi
ICovCisJcG5lZ19jdHh0LT5OYW1lWzBdID0gMHg5MzsKKwlwbmVnX2N0eHQtPk5hbWVbMV0gPSAw
eEFEOworCXBuZWdfY3R4dC0+TmFtZVsyXSA9IDB4MjU7CisJcG5lZ19jdHh0LT5OYW1lWzNdID0g
MHg1MDsKKwlwbmVnX2N0eHQtPk5hbWVbNF0gPSAweDlDOworCXBuZWdfY3R4dC0+TmFtZVs1XSA9
IDB4QjQ7CisJcG5lZ19jdHh0LT5OYW1lWzZdID0gMHgxMTsKKwlwbmVnX2N0eHQtPk5hbWVbN10g
PSAweEU3OworCXBuZWdfY3R4dC0+TmFtZVs4XSA9IDB4QjQ7CisJcG5lZ19jdHh0LT5OYW1lWzld
ID0gMHgyMzsKKwlwbmVnX2N0eHQtPk5hbWVbMTBdID0gMHg4MzsKKwlwbmVnX2N0eHQtPk5hbWVb
MTFdID0gMHhERTsKKwlwbmVnX2N0eHQtPk5hbWVbMTJdID0gMHg5NjsKKwlwbmVnX2N0eHQtPk5h
bWVbMTNdID0gMHg4QjsKKwlwbmVnX2N0eHQtPk5hbWVbMTRdID0gMHhDRDsKKwlwbmVnX2N0eHQt
Pk5hbWVbMTVdID0gMHg3QzsKIH0KIAogc3RhdGljIHZvaWQKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggNTM4ZTIyOTk4MDVmLi4yOWY5NzRm
ODZmMjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21iMnBk
dS5oCkBAIC0yODgsMTIgKzI4OCwxMiBAQCBzdHJ1Y3Qgc21iMl9lbmNyeXB0aW9uX25lZ19jb250
ZXh0IHsKIAlfX2xlMTYJQ2lwaGVyc1sxXTsgLyogQ2lwaGVyc1swXSBzaW5jZSBvbmx5IG9uZSB1
c2VkIG5vdyAqLwogfSBfX3BhY2tlZDsKIAotI2RlZmluZSBQT1NJWF9DVFhUX0RBVEFfTEVOCTgK
KyNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkxNgogc3RydWN0IHNtYjJfcG9zaXhfbmVnX2Nv
bnRleHQgewogCV9fbGUxNglDb250ZXh0VHlwZTsgLyogMHgxMDAgKi8KIAlfX2xlMTYJRGF0YUxl
bmd0aDsKIAlfX2xlMzIJUmVzZXJ2ZWQ7Ci0JX19sZTY0CVJlc2VydmVkMTsgLyogSW4gY2FzZSBu
ZWVkZWQgZm9yIGZ1dHVyZSAoZWcgdmVyc2lvbiBvciBjYXBzKSAqLworCV9fdTgJTmFtZVsxNl07
IC8qIFBPU0lYIGNudHh0IEdVSUQgOTNBRDI1NTA5Q0I0MTFFN0I0MjM4M0RFOTY4QkNEN0MgKi8K
IH0gX19wYWNrZWQ7CiAKIHN0cnVjdCBzbWIyX25lZ290aWF0ZV9yc3AgewotLSAKMi4xNy4xCgo=
--00000000000038f6d80582aca4c0--
