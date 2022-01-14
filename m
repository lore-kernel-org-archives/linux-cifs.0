Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9128C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jan 2022 21:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiANVTx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiANVTx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jan 2022 16:19:53 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C23C061574
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 13:19:52 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id d3so34160335lfv.13
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jan 2022 13:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XKFb6Fl53s2qi21kACRlDeG+z3DnemzG4XQNsK5L4EI=;
        b=oX2e8X3OD8k5DSjcYZVM9VVrYHNapKdBODXhf3evcm1vZpHW4XLAv44rjqsOZl3Aba
         aaXiV078vHiQ8WXC990fmTxq4+O0yeqGuOESsqowJtcXuIEkgr30tLcwze7uzX4RpVHd
         vH8nNtB3B7+oO92qvl4CMdsYsDrWcT0AZyCyne4qf5DcztmsVbK0sM6ou94B0mYKgeOi
         3ANe8UiWM50U2lUK0bbQRRBMajg7uJAXtEFOuC/Xti8tl8vgVOl9vL/dkw5awkNVWng+
         hYVuJ9YbSpW8OxQo4qCJabDacelkQSmath37OePuU+aOp1iKrHUjmCuYU2PrBmZ1HyeJ
         6yTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XKFb6Fl53s2qi21kACRlDeG+z3DnemzG4XQNsK5L4EI=;
        b=hlYdZ6s6Y7wzO7iNNfa/+HNi+2G5ebSdxVwBgdxlEED84L1x1hUDWmz6+XFK5BSAEH
         2p7oixQMcu/ZILVTsKSRmBX+BNXymvfj6A7Tt1y60lPlwao2hXCQ+v7BuNklxWeHfJLw
         12jtCep9zR8lFdcCfgRIXrrwJubQxfvSJ8/K2uUQARh7/nlTEBJeJkSY77C6dSHmtm8C
         kMwGfH6Iyeuvhhr7GuKFLiGemBB4/sXHzknEuJMn5Tmo7SSALViE+mHQF66ykTvsHI77
         2F5a+IGxqnkKD+rVadfn9Za3Hz07cX3K7JMQ24K9fGT2DjJTlxbjMpm/zLEDiDM86PcZ
         X8RA==
X-Gm-Message-State: AOAM532ftDRtMW4vltxotBta24D1NKiS+XU9IWej23zINqqvav5DuYR6
        lJQFlGKIjv4FJQrxirQzIRNvHj5swAoC3vI8jtKpQcQKOWE=
X-Google-Smtp-Source: ABdhPJxwcOKZIUK3kFFkd2ZEziVoRn65Pd6Kn0YxyEILI+0dh5FfBOEkDs2klszOujByHr3/so5JZTiF+PAvLQQ2BVA=
X-Received: by 2002:a05:6512:3090:: with SMTP id z16mr1740181lfd.601.1642195190928;
 Fri, 14 Jan 2022 13:19:50 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jan 2022 15:19:39 -0600
Message-ID: <CAH2r5mvuGfXDAjSJo5xEPkq7D-Usg1pOHR3NQAvK6Z4Uv0tJSA@mail.gmail.com>
Subject: Multichannel patch series reconnect bug
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000001ffd405d5915df6"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000001ffd405d5915df6
Content-Type: text/plain; charset="UTF-8"

I have narrowed down the multichannel patch series bug which causes a
few of the DFS regression tests to fail.   Looks like it is in this
part of the patch
cifs-check-reconnects-for-channels-of-active-tcons-t.patch

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f88d2b10045a..4c2048a8e464 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -119,6 +119,7 @@ enum statusEnum {
  CifsInSessSetup,
  CifsNeedTcon,
  CifsInTcon,
+ CifsNeedFilesInvalidate,
  CifsInFilesInvalidate
 };

@@ -925,6 +926,7 @@ struct cifs_chan {
  */
 struct cifs_ses {
  struct list_head smb_ses_list;
+ struct list_head rlist; /* reconnect list */
  struct list_head tcon_list;
  struct cifs_tcon *tcon_ipc;
  struct mutex session_mutex;
  diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1dafaf7c4e5e..128c71b48002 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -335,6 +335,7 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
  spin_unlock(&cifs_tcp_ses_lock);
  cifs_swn_reset_server_dstaddr(server);
  mutex_unlock(&server->srv_mutex);
+ mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
  }
  } while (server->tcpStatus == CifsNeedReconnect);

@@ -4399,9 +4400,22 @@ int cifs_tree_connect(const unsigned int xid,
struct cifs_tcon *tcon, const stru
  char *tree;
  struct dfs_info3_param ref = {0};

+ /* only send once per connect */
+ spin_lock(&cifs_tcp_ses_lock);
+ if (tcon->ses->status != CifsGood ||
+     (tcon->tidStatus != CifsNew &&
+     tcon->tidStatus != CifsNeedTcon)) {
+ spin_unlock(&cifs_tcp_ses_lock);
+ return 0;
+ }
+ tcon->tidStatus = CifsInTcon;
+ spin_unlock(&cifs_tcp_ses_lock);
+
  tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
- if (!tree)
- return -ENOMEM;
+ if (!tree) {
+ rc = -ENOMEM;
+ goto out;
+ }

  if (tcon->ipc) {
  scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
@@ -4433,11 +4447,18 @@ int cifs_tree_connect(const unsigned int xid,
struct cifs_tcon *tcon, const stru
  kfree(tree);
  cifs_put_tcp_super(sb);

+ if (rc) {
+ spin_lock(&cifs_tcp_ses_lock);
+ tcon->tidStatus = CifsNeedTcon;
+ spin_unlock(&cifs_tcp_ses_lock);
+ }
+
  return rc;
 }
 #else
 int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon,
const struct nls_table *nlsc)
 {
+ int rc;
  const struct smb_version_operations *ops = tcon->ses->server->ops;

  /* only send once per connect */
@@ -4451,6 +4472,13 @@ int cifs_tree_connect(const unsigned int xid,
struct cifs_tcon *tcon, const stru
  tcon->tidStatus = CifsInTcon;
  spin_unlock(&cifs_tcp_ses_lock);

- return ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+ rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
+ if (rc) {
+ spin_lock(&cifs_tcp_ses_lock);
+ tcon->tidStatus = CifsNeedTcon;
+ spin_unlock(&cifs_tcp_ses_lock);
+ }
+
+ return rc;
 }
 #endif
-- 
Thanks,

Steve

--00000000000001ffd405d5915df6
Content-Type: text/x-patch; charset="US-ASCII"; name="check-recon-small.patch"
Content-Disposition: attachment; filename="check-recon-small.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kyewkrqk0>
X-Attachment-Id: f_kyewkrqk0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBmODhkMmIxMDA0NWEuLjRjMjA0OGE4ZTQ2NCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xv
Yi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTE5LDYgKzExOSw3IEBAIGVudW0gc3Rh
dHVzRW51bSB7CiAJQ2lmc0luU2Vzc1NldHVwLAogCUNpZnNOZWVkVGNvbiwKIAlDaWZzSW5UY29u
LAorCUNpZnNOZWVkRmlsZXNJbnZhbGlkYXRlLAogCUNpZnNJbkZpbGVzSW52YWxpZGF0ZQogfTsK
IApAQCAtOTI1LDYgKzkyNiw3IEBAIHN0cnVjdCBjaWZzX2NoYW4gewogICovCiBzdHJ1Y3QgY2lm
c19zZXMgewogCXN0cnVjdCBsaXN0X2hlYWQgc21iX3Nlc19saXN0OworCXN0cnVjdCBsaXN0X2hl
YWQgcmxpc3Q7IC8qIHJlY29ubmVjdCBsaXN0ICovCiAJc3RydWN0IGxpc3RfaGVhZCB0Y29uX2xp
c3Q7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbl9pcGM7CiAJc3RydWN0IG11dGV4IHNlc3Npb25f
bXV0ZXg7CiAJZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0
LmMKaW5kZXggMWRhZmFmN2M0ZTVlLi4xMjhjNzFiNDgwMDIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0zMzUsNiArMzM1LDcgQEAgc3Rh
dGljIGludCBfX2NpZnNfcmVjb25uZWN0KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwK
IAkJCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CiAJCQljaWZzX3N3bl9yZXNldF9z
ZXJ2ZXJfZHN0YWRkcihzZXJ2ZXIpOwogCQkJbXV0ZXhfdW5sb2NrKCZzZXJ2ZXItPnNydl9tdXRl
eCk7CisJCQltb2RfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsICZzZXJ2ZXItPnJlY29ubmVjdCwg
MCk7CiAJCX0KIAl9IHdoaWxlIChzZXJ2ZXItPnRjcFN0YXR1cyA9PSBDaWZzTmVlZFJlY29ubmVj
dCk7CiAKQEAgLTQzOTksOSArNDQwMCwyMiBAQCBpbnQgY2lmc190cmVlX2Nvbm5lY3QoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3Qgc3RydQogCWNo
YXIgKnRyZWU7CiAJc3RydWN0IGRmc19pbmZvM19wYXJhbSByZWYgPSB7MH07CiAKKwkvKiBvbmx5
IHNlbmQgb25jZSBwZXIgY29ubmVjdCAqLworCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2sp
OworCWlmICh0Y29uLT5zZXMtPnN0YXR1cyAhPSBDaWZzR29vZCB8fAorCSAgICAodGNvbi0+dGlk
U3RhdHVzICE9IENpZnNOZXcgJiYKKwkgICAgdGNvbi0+dGlkU3RhdHVzICE9IENpZnNOZWVkVGNv
bikpIHsKKwkJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwkJcmV0dXJuIDA7CisJ
fQorCXRjb24tPnRpZFN0YXR1cyA9IENpZnNJblRjb247CisJc3Bpbl91bmxvY2soJmNpZnNfdGNw
X3Nlc19sb2NrKTsKKwogCXRyZWUgPSBremFsbG9jKE1BWF9UUkVFX1NJWkUsIEdGUF9LRVJORUwp
OwotCWlmICghdHJlZSkKLQkJcmV0dXJuIC1FTk9NRU07CisJaWYgKCF0cmVlKSB7CisJCXJjID0g
LUVOT01FTTsKKwkJZ290byBvdXQ7CisJfQogCiAJaWYgKHRjb24tPmlwYykgewogCQlzY25wcmlu
dGYodHJlZSwgTUFYX1RSRUVfU0laRSwgIlxcXFwlc1xcSVBDJCIsIHNlcnZlci0+aG9zdG5hbWUp
OwpAQCAtNDQzMywxMSArNDQ0NywxOCBAQCBpbnQgY2lmc190cmVlX2Nvbm5lY3QoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3Qgc3RydQogCWtmcmVl
KHRyZWUpOwogCWNpZnNfcHV0X3RjcF9zdXBlcihzYik7CiAKKwlpZiAocmMpIHsKKwkJc3Bpbl9s
b2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCXRjb24tPnRpZFN0YXR1cyA9IENpZnNOZWVkVGNv
bjsKKwkJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwl9CisKIAlyZXR1cm4gcmM7
CiB9CiAjZWxzZQogaW50IGNpZnNfdHJlZV9jb25uZWN0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIGNvbnN0IHN0cnVjdCBubHNfdGFibGUgKm5sc2MpCiB7
CisJaW50IHJjOwogCWNvbnN0IHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zICpvcHMgPSB0
Y29uLT5zZXMtPnNlcnZlci0+b3BzOwogCiAJLyogb25seSBzZW5kIG9uY2UgcGVyIGNvbm5lY3Qg
Ki8KQEAgLTQ0NTEsNiArNDQ3MiwxMyBAQCBpbnQgY2lmc190cmVlX2Nvbm5lY3QoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgY29uc3Qgc3RydQogCXRjb24t
PnRpZFN0YXR1cyA9IENpZnNJblRjb247CiAJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2Nr
KTsKIAotCXJldHVybiBvcHMtPnRyZWVfY29ubmVjdCh4aWQsIHRjb24tPnNlcywgdGNvbi0+dHJl
ZU5hbWUsIHRjb24sIG5sc2MpOworCXJjID0gb3BzLT50cmVlX2Nvbm5lY3QoeGlkLCB0Y29uLT5z
ZXMsIHRjb24tPnRyZWVOYW1lLCB0Y29uLCBubHNjKTsKKwlpZiAocmMpIHsKKwkJc3Bpbl9sb2Nr
KCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCXRjb24tPnRpZFN0YXR1cyA9IENpZnNOZWVkVGNvbjsK
KwkJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwl9CisKKwlyZXR1cm4gcmM7CiB9
CiAjZW5kaWYK
--00000000000001ffd405d5915df6--
