Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B54C7618B
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 23:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjCNXdM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCNXdL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 19:33:11 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B0738B44
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 16:33:10 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUHMbk4HVQ3cMaPv9cOozVq4JrvXW3GMGQ1hQuvKjPg=;
        b=mNGaTWNm+tgqXrz7CbmOXr9eGbzu8KsmKO60a0R5LZVGIgaH3klLcVeKuEKK6HZt+d+L8I
        Jr0q9oytLfassBDu3YihFdXem6QgQ3b+SvVt1X+0HoZZXBEL0tanPCf/Ps2CpPEfo6yYZp
        rd2QyN7wfNQoKpeFQaCQstS4unbni50KBy6faPshdvJC/S8VImhcYm26CTvd4z56bwohom
        bGvxwRHMOyHeVJLC4tNyNIv0jxLVFPCcbvmkwwiZadhT7qhxGPSFTFsj/Gahb8FH6FhHBe
        Xui9r6eClPGna0R+s3dWj7arCClBSlRrtH22tjzIDVsL9BDBLn2Ph9I7V2hXpg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1678836789; a=rsa-sha256;
        cv=none;
        b=ReygoQNWHZVWU8ygGAHMZqDPyW1trHxqsM8nTc6oRhpPJjzeI7OhFThEUN2hXgymRfT4jr
        mJ89A4/yfuslKrW6NNYPC0zlA9fXlptqrqXXf4kYKgvjD2tMK4AJhqmTPYn3noZczVEkKU
        dS7Z/ielZIfFUBCml9GIvAG73V+yRojot0WZGXvfL7vHF93MZRwqIge1dWlaYyBo6okroj
        UcSngY0o9O/pKc0KiqIA/23KtWazQm7BGJZOfM48lcR6AJzQ2LrCgEccR40iSVXgNPvuq0
        lpupE5Z2nNZvXQaVXb/lTAaVcuLozYn+w6oXc1xGbBz0GPiziQ6ziVeP9jioog==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1678836789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUHMbk4HVQ3cMaPv9cOozVq4JrvXW3GMGQ1hQuvKjPg=;
        b=sc1jw5UlYG88p3cKd0CbNBiQ7X2l322rgSpGBFHFpBkY0tUdbqyX3VdAyUEFw/GdSrsgC9
        2nqlcJtPs0eXqAmX5ocoS5+4PeBnPTRYUfDdVwaYgLWjlOTxf05/4dBoCuecBx/e3PvWuS
        9BdNTNQNI07f7Nbxty5mC+BenII1GjAlBQqxTqr0xeExFdWar4v5OiMIaWsEiiyD/dCkut
        oZ2lEkdmJYMq3Mbe2Ma4bw1COCEUgOBpNg+YgNYb3bVd0sDYz+Pv2V+mEDS1t2zPp8qkc/
        uXeFaLcaesLZOBJ7fko2mTiPUxtr7wau7fB9293HvZV9Ai3aSBxluRKq7YPu6g==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/4] cifs: return DFS root session id in DebugData
Date:   Tue, 14 Mar 2023 20:32:55 -0300
Message-Id: <20230314233256.16468-3-pc.crab@mail.manguebit.com>
In-Reply-To: <20230314233256.16468-1-pc@manguebit.com>
References: <20230314233256.16468-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Return the DFS root session id in /proc/fs/cifs/DebugData to make it
easier to track which IPC tcon was used to get new DFS referrals for a
specific connection.

A simple output of it would be

  Sessions:
  1) Address: 192.168.1.13 Uses: 1 Capability: 0x300067   Session Status: 1
  Security type: RawNTLMSSP  SessionId: 0xd80000000009
  User: 0 Cred User: 0
  DFS root session id: 0x128006c000035

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifs_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 1911f7016fa1..19a70a69c760 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -420,6 +420,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				   from_kuid(&init_user_ns, ses->linux_uid),
 				   from_kuid(&init_user_ns, ses->cred_uid));
 
+			if (ses->dfs_root_ses) {
+				seq_printf(m, "\n\tDFS root session id: 0x%llx",
+					   ses->dfs_root_ses->Suid);
+			}
+
 			spin_lock(&ses->chan_lock);
 			if (CIFS_CHAN_NEEDS_RECONNECT(ses, 0))
 				seq_puts(m, "\tPrimary channel: DISCONNECTED ");
-- 
2.39.2

