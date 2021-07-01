Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FF6C11F64
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 17:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6385261407
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jul 2021 17:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGARbT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Jul 2021 13:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGARbS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Jul 2021 13:31:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262CCC061762
        for <linux-cifs@vger.kernel.org>; Thu,  1 Jul 2021 10:28:47 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id p24so9582847ljj.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 Jul 2021 10:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sUKTCKGOlEVhngMnwQAbfvnc7VUhol/h9zwsDZ/ptLc=;
        b=S3j5njcQpzsBRPs8O/APU9P6e2Q+LGyEeMqBc5pIKwkyPKB0z9hKiRwiNPXJNzJ4az
         8PvpSOnGoWGDmgAnk5rgIxvVAOLUKHfKhaDn5Xn21lkcbM7fJcoaLx1hLdTn0My6jb/o
         xF1RAc0e4hmwI1dc17T4/IxzCTyVa7EMoXJC4z/YDsUzJ5LNUSaFD8gYB8KyRfAsMHbb
         4KzbduL5RQMuPfenIG4i7dPGkcyq/KYsghLI0dZFUV1LCYawbuelIkmjJotHJeT0mTJF
         pBIxr8TiJkAyOJn0jvAPExeXMmXvLDM5q5oWNfPUI+DLIjiGwepO9twTYlJW2ItG3BF8
         wFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sUKTCKGOlEVhngMnwQAbfvnc7VUhol/h9zwsDZ/ptLc=;
        b=hZu/MOEUI3A6vj+kPBkPPvvByUXv9NcG1MumfsoqzFsHs1JAhvFj7H/DRcVE3ooGW4
         vSgtIkBtFwvGzDIKVdc0rKBmBZ79ihzDbwrq8URiA343Si8gtAsVkRc0fLuaKP5ALdBe
         ocnyzv+D/dhzFcjlTDQSR4Yoc7dU4o94zMMUEMYcdgFyf/svtgIKSIq25wq2aLTybIDa
         /MvRUo6cM8wH3blfwJMHpmccDXYw8PExHsZUhmRKSedz8k8tiGM0sqTpLvFS/uW4g7ET
         vSzgI75QT+i+mSzFnQzUjspcLqnY26VbNXouFyj4AdrgZKsT7xfW3KoD2gPgqJfU/e/Z
         pqYg==
X-Gm-Message-State: AOAM531hDJqn2XsIs09fbWu/bN7sRq+WKBeHPnOqPLQL0Yei7NmXNcMJ
        7KktWHnw5PnyhJbv3Wh1ZxOXpsA4qTED9YYeXCalwvgOf02A/A==
X-Google-Smtp-Source: ABdhPJzztH/Q9xPPGGVYS3tPbOBZiPKv3i8zaxK6D+WlnUtrCBsheeyl/QlnbkCJ4JyciMGsOKF6cRQwVgm9E69LsM8=
X-Received: by 2002:a2e:960e:: with SMTP id v14mr547329ljh.148.1625160524625;
 Thu, 01 Jul 2021 10:28:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Jul 2021 12:28:33 -0500
Message-ID: <CAH2r5muOpGHkvPyxJy_Qbp7gLC4ssL4eBOcY59U9+7KAjFHzcQ@mail.gmail.com>
Subject: [PATCH][CIFS] make locking consistent around the server session status
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c6620905c6132be5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c6620905c6132be5
Content-Type: text/plain; charset="UTF-8"

There were three places where we were not taking the spinlock
around updates to server->tcpStatus when it was being modified.
To be consistent (also removes Coverity warning) and to remove
possibility of race best to lock all places where it is updated.

Addresses-Coverity: 1399512 ("Data race condition")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsglob.h  | 3 ++-
 fs/cifs/connect.c   | 4 ++++
 fs/cifs/transport.c | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3100f8b66e60..921680fb7931 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -577,6 +577,7 @@ struct TCP_Server_Info {
  char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
  struct smb_version_operations *ops;
  struct smb_version_values *vals;
+ /* updates to tcpStatus protected by GlobalMid_Lock */
  enum statusEnum tcpStatus; /* what we think the status is */
  char *hostname; /* hostname portion of UNC string */
  struct socket *ssocket;
@@ -1785,7 +1786,7 @@ require use of the stronger protocol */
  * list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
  *      list operations on global DnotifyReqList
- *      updates to ses->status
+ *      updates to ses->status and TCP_Server_Info->tcpStatus
  *      updates to server->CurrentMid
  *  tcp_ses_lock protects:
  * list operations on tcp and SMB session lists
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5d269f583dac..944fb92f50c7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
  * to the struct since the kernel thread not created yet
  * no need to spinlock this init of tcpStatus or srv_count
  */
+ spin_lock(&GlobalMid_Lock);
  tcp_ses->tcpStatus = CifsNew;
+ spin_unlock(&GlobalMid_Lock);
  ++tcp_ses->srv_count;

  if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
@@ -1403,7 +1405,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
  goto out_err_crypto_release;
  }
  tcp_ses->min_offload = ctx->min_offload;
+ spin_lock(&GlobalMid_Lock);
  tcp_ses->tcpStatus = CifsNeedNegotiate;
+ spin_unlock(&GlobalMid_Lock);

  if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
  tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f65f9a692ca2..75a95de320cf 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -431,7 +431,9 @@ __smb_send_rqst(struct TCP_Server_Info *server,
int num_rqst,
  * be taken as the remainder of this one. We need to kill the
  * socket so the server throws away the partial SMB
  */
+ spin_lock(&GlobalMid_Lock);
  server->tcpStatus = CifsNeedReconnect;
+ spin_unlock(&GlobalMid_Lock);
  trace_smb3_partial_send_reconnect(server->CurrentMid,
    server->conn_id, server->hostname);
  }

-- 
Thanks,

Steve

--000000000000c6620905c6132be5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-make-locking-consistent-around-the-server-sessi.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-make-locking-consistent-around-the-server-sessi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kql6jnh60>
X-Attachment-Id: f_kql6jnh60

RnJvbSBkYzQzZWUxZGY5Yjk1YzRkOWUxNzI4NTkyNmQ2NGM0NjAwMzQwZjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMSBKdWwgMjAyMSAxMjoyMjo0NyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IG1ha2UgbG9ja2luZyBjb25zaXN0ZW50IGFyb3VuZCB0aGUgc2VydmVyIHNlc3Npb24KIHN0
YXR1cwoKVGhlcmUgd2VyZSB0aHJlZSBwbGFjZXMgd2hlcmUgd2Ugd2VyZSBub3QgdGFraW5nIHRo
ZSBzcGlubG9jawphcm91bmQgdXBkYXRlcyB0byBzZXJ2ZXItPnRjcFN0YXR1cyB3aGVuIGl0IHdh
cyBiZWluZyBtb2RpZmllZC4KVG8gYmUgY29uc2lzdGVudCAoYWxzbyByZW1vdmVzIENvdmVyaXR5
IHdhcm5pbmcpIGFuZCB0byByZW1vdmUKcG9zc2liaWxpdHkgb2YgcmFjZSBiZXN0IHRvIGxvY2sg
YWxsIHBsYWNlcyB3aGVyZSBpdCBpcyB1cGRhdGVkLgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxMzk5
NTEyICgiRGF0YSByYWNlIGNvbmRpdGlvbiIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggIHwgMyArKy0K
IGZzL2NpZnMvY29ubmVjdC5jICAgfCA0ICsrKysKIGZzL2NpZnMvdHJhbnNwb3J0LmMgfCAyICsr
CiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCAzMTAw
ZjhiNjZlNjAuLjkyMTY4MGZiNzkzMSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisr
KyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtNTc3LDYgKzU3Nyw3IEBAIHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gewogCWNoYXIgc2VydmVyX1JGQzEwMDFfbmFtZVtSRkMxMDAxX05BTUVfTEVOX1dJ
VEhfTlVMTF07CiAJc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMJKm9wczsKIAlzdHJ1Y3Qg
c21iX3ZlcnNpb25fdmFsdWVzCSp2YWxzOworCS8qIHVwZGF0ZXMgdG8gdGNwU3RhdHVzIHByb3Rl
Y3RlZCBieSBHbG9iYWxNaWRfTG9jayAqLwogCWVudW0gc3RhdHVzRW51bSB0Y3BTdGF0dXM7IC8q
IHdoYXQgd2UgdGhpbmsgdGhlIHN0YXR1cyBpcyAqLwogCWNoYXIgKmhvc3RuYW1lOyAvKiBob3N0
bmFtZSBwb3J0aW9uIG9mIFVOQyBzdHJpbmcgKi8KIAlzdHJ1Y3Qgc29ja2V0ICpzc29ja2V0OwpA
QCAtMTc4NSw3ICsxNzg2LDcgQEAgcmVxdWlyZSB1c2Ugb2YgdGhlIHN0cm9uZ2VyIHByb3RvY29s
ICovCiAgKglsaXN0IG9wZXJhdGlvbnMgb24gcGVuZGluZ19taWRfcSBhbmQgb3Bsb2NrUQogICog
ICAgICB1cGRhdGVzIHRvIFhJRCBjb3VudGVycywgbXVsdGlwbGV4IGlkICBhbmQgU01CIHNlcXVl
bmNlIG51bWJlcnMKICAqICAgICAgbGlzdCBvcGVyYXRpb25zIG9uIGdsb2JhbCBEbm90aWZ5UmVx
TGlzdAotICogICAgICB1cGRhdGVzIHRvIHNlcy0+c3RhdHVzCisgKiAgICAgIHVwZGF0ZXMgdG8g
c2VzLT5zdGF0dXMgYW5kIFRDUF9TZXJ2ZXJfSW5mby0+dGNwU3RhdHVzCiAgKiAgICAgIHVwZGF0
ZXMgdG8gc2VydmVyLT5DdXJyZW50TWlkCiAgKiAgdGNwX3Nlc19sb2NrIHByb3RlY3RzOgogICoJ
bGlzdCBvcGVyYXRpb25zIG9uIHRjcCBhbmQgU01CIHNlc3Npb24gbGlzdHMKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggNWQyNjlmNTgzZGFj
Li45NDRmYjkyZjUwYzcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCkBAIC0xMzU4LDcgKzEzNTgsOSBAQCBjaWZzX2dldF90Y3Bfc2Vzc2lvbihz
dHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJICogdG8gdGhlIHN0cnVjdCBzaW5jZSB0aGUg
a2VybmVsIHRocmVhZCBub3QgY3JlYXRlZCB5ZXQKIAkgKiBubyBuZWVkIHRvIHNwaW5sb2NrIHRo
aXMgaW5pdCBvZiB0Y3BTdGF0dXMgb3Igc3J2X2NvdW50CiAJICovCisJc3Bpbl9sb2NrKCZHbG9i
YWxNaWRfTG9jayk7CiAJdGNwX3Nlcy0+dGNwU3RhdHVzID0gQ2lmc05ldzsKKwlzcGluX3VubG9j
aygmR2xvYmFsTWlkX0xvY2spOwogCSsrdGNwX3Nlcy0+c3J2X2NvdW50OwogCiAJaWYgKGN0eC0+
ZWNob19pbnRlcnZhbCA+PSBTTUJfRUNIT19JTlRFUlZBTF9NSU4gJiYKQEAgLTE0MDMsNyArMTQw
NSw5IEBAIGNpZnNfZ2V0X3RjcF9zZXNzaW9uKHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCkK
IAkJZ290byBvdXRfZXJyX2NyeXB0b19yZWxlYXNlOwogCX0KIAl0Y3Bfc2VzLT5taW5fb2ZmbG9h
ZCA9IGN0eC0+bWluX29mZmxvYWQ7CisJc3Bpbl9sb2NrKCZHbG9iYWxNaWRfTG9jayk7CiAJdGNw
X3Nlcy0+dGNwU3RhdHVzID0gQ2lmc05lZWROZWdvdGlhdGU7CisJc3Bpbl91bmxvY2soJkdsb2Jh
bE1pZF9Mb2NrKTsKIAogCWlmICgoY3R4LT5tYXhfY3JlZGl0cyA8IDIwKSB8fCAoY3R4LT5tYXhf
Y3JlZGl0cyA+IDYwMDAwKSkKIAkJdGNwX3Nlcy0+bWF4X2NyZWRpdHMgPSBTTUIyX01BWF9DUkVE
SVRTX0FWQUlMQUJMRTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMgYi9mcy9jaWZz
L3RyYW5zcG9ydC5jCmluZGV4IGY2NWY5YTY5MmNhMi4uNzVhOTVkZTMyMGNmIDEwMDY0NAotLS0g
YS9mcy9jaWZzL3RyYW5zcG9ydC5jCisrKyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKQEAgLTQzMSw3
ICs0MzEsOSBAQCBfX3NtYl9zZW5kX3Jxc3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
LCBpbnQgbnVtX3Jxc3QsCiAJCSAqIGJlIHRha2VuIGFzIHRoZSByZW1haW5kZXIgb2YgdGhpcyBv
bmUuIFdlIG5lZWQgdG8ga2lsbCB0aGUKIAkJICogc29ja2V0IHNvIHRoZSBzZXJ2ZXIgdGhyb3dz
IGF3YXkgdGhlIHBhcnRpYWwgU01CCiAJCSAqLworCQlzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2Nr
KTsKIAkJc2VydmVyLT50Y3BTdGF0dXMgPSBDaWZzTmVlZFJlY29ubmVjdDsKKwkJc3Bpbl91bmxv
Y2soJkdsb2JhbE1pZF9Mb2NrKTsKIAkJdHJhY2Vfc21iM19wYXJ0aWFsX3NlbmRfcmVjb25uZWN0
KHNlcnZlci0+Q3VycmVudE1pZCwKIAkJCQkJCSAgc2VydmVyLT5jb25uX2lkLCBzZXJ2ZXItPmhv
c3RuYW1lKTsKIAl9Ci0tIAoyLjMwLjIKCg==
--000000000000c6620905c6132be5--
