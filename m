Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA9AC4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Dec 2022 15:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLQPQv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Dec 2022 10:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLQPQr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Dec 2022 10:16:47 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8538465AA
        for <linux-cifs@vger.kernel.org>; Sat, 17 Dec 2022 07:16:46 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id cf42so7782144lfb.1
        for <linux-cifs@vger.kernel.org>; Sat, 17 Dec 2022 07:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zJVwAqIW70BC3wOc8affCCoPDTXie9/MZ+Fr6tggh78=;
        b=UUqCjZ2ZoFQ8RMJxNnhQpcneJcLwcRHdPatFvp4mQPHl2KLIloqKdURH36BRz2Vkbn
         v2hlGCmSDdZLt9q+QPdBXlXJyVpsXk11i0OMxsuNDV/mdKPWDzpph089Rth7ZxLRUflz
         1Qtl9uK5OfpgmMgpuCL9clxlr20t6ApUM4BIXxDE/xvacFx4dFz/Ate8+5p7SkQaqSeD
         WDk1GxpamX4X3CLwrx/GZun2OPfX3BJi/lyR0tTaf6W108fWATBJC2qf4GjhY+tXtH6B
         q6EPRoCZxcRDc33oqjp0nQdzTWxTePWK3/eqk38xxxyg92oZM1f7qfzxrO6HYHPbIYQq
         BD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zJVwAqIW70BC3wOc8affCCoPDTXie9/MZ+Fr6tggh78=;
        b=4rPVSnBfbS5paORoXh4TLZ66q6lE7bC9ek2osX6JGnhuJAkQX3WGtceOinTxXaiAl/
         pmcxZcnxOAG5b9c1EiivCnJqjn/iOdJkNzbLlT2hj3Ens9smBA3r4G4MXb2xB4DYfn3R
         ZgcD7HPw7d4sI+oLnx1SlpZZMRw6e7clhRIwzBBX+b22utK+HbA3MaZWOlbx675onSAH
         yuaRC8NFglkX8K/rG47QsBk3rHspKgiYMfxSqOjezqccNaznNxkC4vm7hqLcK0BaNeTr
         SKJiucVEG+8daw6QivUuzQ0o1/lhAv/VLgCZqHRvfKrHQYwAgdLsD/HK9mMe6I0CJ/1k
         G/5A==
X-Gm-Message-State: ANoB5pmlsaNpHLY9kSnGY1A/Qo/ajCx7XUgA+AbA2iTBYrcH0LyLnSS5
        22w/dlw2VtiV1CFGler6TCwzjjZPl7H7upQ7SKiUId5TFp4=
X-Google-Smtp-Source: AA0mqf4rQfwKcLbUumxkP5DELUNEePjn0rvqJWVo3ttxrjmznrmunD455vzbRLKH7NlrBfbA6Eqb69nAQmivdLItxvs=
X-Received: by 2002:a05:6512:3ca0:b0:4a2:2c4b:8138 with SMTP id
 h32-20020a0565123ca000b004a22c4b8138mr27601926lfv.14.1671290204238; Sat, 17
 Dec 2022 07:16:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 17 Dec 2022 09:16:33 -0600
Message-ID: <CAH2r5mv_wAAZ=_+PvgAeaKZhXM-6Ym7vpsRifZ5qg6Gmb1UCBw@mail.gmail.com>
Subject: [PATCH][SMB3 client] Two reconnect patches
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="000000000000f174a705f0079202"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f174a705f0079202
Content-Type: text/plain; charset="UTF-8"

See attached. Both cc: stable

"cifs: set correct tcon status after initial tree connect"

cifs_tcon::status wasn't correctly updated to TID_GOOD after initial
tree connect thus staying at TID_NEW as long as it was connected.

and

"cifs: set correct ipc status after initial tree connect"

cifs_tcon::status wasn't correctly updated to TID_GOOD after
establishing initial IPC connection thus staying at TID_NEW as long as
it wasn't reconnected.


-- 
Thanks,

Steve

--000000000000f174a705f0079202
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-set-correct-tcon-status-after-initial-tree-conn.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-set-correct-tcon-status-after-initial-tree-conn.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lbs2wkfq0>
X-Attachment-Id: f_lbs2wkfq0

RnJvbSBiMjQ4NTg2YTQ5YTc3MjlmNzNjNTA0YjFlN2I5NThjYWVhNDVlOTI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogVHVl
LCAxMyBEZWMgMjAyMiAwOToxNToyMyAtMDMwMApTdWJqZWN0OiBbUEFUQ0ggMDEvMTddIGNpZnM6
IHNldCBjb3JyZWN0IHRjb24gc3RhdHVzIGFmdGVyIGluaXRpYWwgdHJlZQogY29ubmVjdAoKY2lm
c190Y29uOjpzdGF0dXMgd2Fzbid0IGNvcnJlY3RseSB1cGRhdGVkIHRvIFRJRF9HT09EIGFmdGVy
IGluaXRpYWwKdHJlZSBjb25uZWN0IHRodXMgc3RheWluZyBhdCBUSURfTkVXIGFzIGxvbmcgYXMg
aXQgd2FzIGNvbm5lY3RlZC4KCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYt
Ynk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4KU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5j
IHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9mcy9j
aWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGU4MDI1MmE4MzIyNS4uZWRh
NzVjOTlhMGY1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nv
bm5lY3QuYwpAQCAtMjYwMCw2ICsyNjAwLDcgQEAgY2lmc19nZXRfdGNvbihzdHJ1Y3QgY2lmc19z
ZXMgKnNlcywgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4KQogCXRjb24tPm5vZGVsZXRlID0g
Y3R4LT5ub2RlbGV0ZTsKIAl0Y29uLT5sb2NhbF9sZWFzZSA9IGN0eC0+bG9jYWxfbGVhc2U7CiAJ
SU5JVF9MSVNUX0hFQUQoJnRjb24tPnBlbmRpbmdfb3BlbnMpOworCXRjb24tPnN0YXR1cyA9IFRJ
RF9HT09EOwogCiAJLyogc2NoZWR1bGUgcXVlcnkgaW50ZXJmYWNlcyBwb2xsICovCiAJSU5JVF9E
RUxBWUVEX1dPUksoJnRjb24tPnF1ZXJ5X2ludGVyZmFjZXMsCi0tIAoyLjM0LjEKCg==
--000000000000f174a705f0079202
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-set-correct-ipc-status-after-initial-tree-conne.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-set-correct-ipc-status-after-initial-tree-conne.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lbs2xwhv1>
X-Attachment-Id: f_lbs2xwhv1

RnJvbSA4NmZlMGZhODc0N2ZiMWJjNGNjNDRmYzE5NjZlMDk1OWZlNzUyZjM4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogRnJp
LCAxNiBEZWMgMjAyMiAxNDowMDoxOSAtMDMwMApTdWJqZWN0OiBbUEFUQ0ggMDIvMTddIGNpZnM6
IHNldCBjb3JyZWN0IGlwYyBzdGF0dXMgYWZ0ZXIgaW5pdGlhbCB0cmVlIGNvbm5lY3QKCmNpZnNf
dGNvbjo6c3RhdHVzIHdhc24ndCBjb3JyZWN0bHkgdXBkYXRlZCB0byBUSURfR09PRCBhZnRlcgpl
c3RhYmxpc2hpbmcgaW5pdGlhbCBJUEMgY29ubmVjdGlvbiB0aHVzIHN0YXlpbmcgYXQgVElEX05F
VyBhcyBsb25nIGFzCml0IHdhc24ndCByZWNvbm5lY3RlZC4KCkNjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnClNpZ25lZC1vZmYtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4K
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvY29ubmVjdC5jIHwgNyArKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIv
ZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZWRhNzVjOTlhMGY1Li5mNTE3MTVkM2UyZjIgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0xODcx
LDYgKzE4NzEsOSBAQCBjaWZzX3NldHVwX2lwYyhzdHJ1Y3QgY2lmc19zZXMgKnNlcywgc3RydWN0
IHNtYjNfZnNfY29udGV4dCAqY3R4KQogCiAJY2lmc19kYmcoRllJLCAiSVBDIHRjb24gcmM9JWQg
aXBjIHRpZD0weCV4XG4iLCByYywgdGNvbi0+dGlkKTsKIAorCXNwaW5fbG9jaygmdGNvbi0+dGNf
bG9jayk7CisJdGNvbi0+c3RhdHVzID0gVElEX0dPT0Q7CisJc3Bpbl91bmxvY2soJnRjb24tPnRj
X2xvY2spOwogCXNlcy0+dGNvbl9pcGMgPSB0Y29uOwogb3V0OgogCXJldHVybiByYzsKQEAgLTIy
NzgsMTAgKzIyODEsMTAgQEAgY2lmc19nZXRfc21iX3NlcyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpzZXJ2ZXIsIHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkKIAlsaXN0X2FkZCgmc2VzLT5z
bWJfc2VzX2xpc3QsICZzZXJ2ZXItPnNtYl9zZXNfbGlzdCk7CiAJc3Bpbl91bmxvY2soJmNpZnNf
dGNwX3Nlc19sb2NrKTsKIAotCWZyZWVfeGlkKHhpZCk7Ci0KIAljaWZzX3NldHVwX2lwYyhzZXMs
IGN0eCk7CiAKKwlmcmVlX3hpZCh4aWQpOworCiAJcmV0dXJuIHNlczsKIAogZ2V0X3Nlc19mYWls
OgotLSAKMi4zNC4xCgo=
--000000000000f174a705f0079202--
