Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B05367;
	Tue,  5 Aug 2025 06:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754376868; cv=none; b=H6sBnYoq5MD5fXRMFVUZQhUVS0uRDsHQYwuqR1L/Lnys5alYMQQz0teIhpZaZVo7p0ukg3uLTp/pDU+YDRu/C9Pmfzg+cn0EJ4MgPX+JyR6uQf0JB8+xFtfdApptXJnrTtxFZSx3vXMw451iefRddxAPLHCD8BcB5NZ036fLzqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754376868; c=relaxed/simple;
	bh=x+wpYcTxgQqY8WbFv8+qBKtjyoB1CKWfYzC2FQbFEa4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vdw0s/7owpmJ0r0k8+HxXU2MHF0hu2J24EwtVnGNaUZOmYf10IAVKFrbSIr0x0ZFDJNlKX1hKOexU7M2RHRU6R8cBQgHliz36RZRLadQGwwD9/Iq/bR7etQPZyuSGiLVGgm5aspyMxOZ6EY/OY7TehW6J1ADZTsJy5RUn15fXzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bx40c0hQGzYQtvm;
	Tue,  5 Aug 2025 14:54:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BBD911A15D6;
	Tue,  5 Aug 2025 14:54:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3chObqpForbmECg--.23530S4;
	Tue, 05 Aug 2025 14:54:21 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 0/4] Fix mid_q_entry memory leaks in SMB client
Date: Tue,  5 Aug 2025 14:47:04 +0800
Message-Id: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3chObqpForbmECg--.23530S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1rGr48ur4kWFy8JF4fXwb_yoWrAFyDpF
	Waga43Gr18Jr93Zwn3Jw48Aa4rAwn5GF13GFW7Kw1Sy3W5uF1Fqrn7tr1FgFWxArWkXr1j
	qw4jyr1j93WDZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

I've been investigating a pretty nasty memory leak in the SMB client. When
compound requests get interrupted by signals, we end up with mid_q_entry
structures and server buffers that never get freed[1].

User foreground process                    cifsd
cifs_readdir
 open_cached_dir
  cifs_send_recv
   compound_send_recv
    smb2_setup_request
     smb2_mid_entry_alloc
      smb2_get_mid_entry
       smb2_mid_entry_alloc
        mempool_alloc // alloc mid
        kref_init(&temp->refcount); // refcount = 1
     mid[0]->callback = cifs_compound_callback;
     mid[1]->callback = cifs_compound_last_callback;
     smb_send_rqst
     rc = wait_for_response
      wait_event_state TASK_KILLABLE
                                  cifs_demultiplex_thread
                                    allocate_buffers
                                      server->bigbuf = cifs_buf_get()
                                    standard_receive3
                                      ->find_mid()
                                        smb2_find_mid
                                          __smb2_find_mid
                                           kref_get(&mid->refcount) // +1
                                      cifs_handle_standard
                                        handle_mid
                                         /* bigbuf will also leak */
                                         mid->resp_buf = server->bigbuf
                                         server->bigbuf = NULL;
                                         dequeue_mid
                                     /* in for loop */
                                    mids[0]->callback
                                      cifs_compound_callback
    /* Signal interrupts wait: rc = -ERESTARTSYS */
    /* if (... || midQ[i]->mid_state == MID_RESPONSE_RECEIVED) *?
    midQ[0]->callback = cifs_cancelled_callback;
    cancelled_mid[i] = true;
                                       /* The change comes too late */
                                       mid->mid_state = MID_RESPONSE_READY
                                    release_mid  // -1
    /* cancelled_mid[i] == true causes mid won't be released
       in compound_send_recv cleanup */
    /* cifs_cancelled_callback won't executed to release mid */

The core issue is a race condition where cifs_cancelled_callback never
gets a chance to run, so cleanup never happens. I've spent quite a bit
of time trying to understand how to fix this safely.

Honestly, my first instinct was to just patch the callback assignment
logic directly. But the more I dug into it, the more I realized that
the current locking scheme makes this really tricky to do safely. We
have one big lock protecting multiple different things, and trying to
fix the race condition directly felt like playing with fire.

I kept running into scenarios where a "simple" fix could introduce
deadlocks or new race conditions. After looking at this from different
angles, I came to the conclusion that I needed to refactor the locking
first to create a safe foundation for the actual fix.

Patches 1-3 are foundational refactoring. These three patches rename
locks for clarity, separate counter protection from queue operations,
and replace the confusing mid_flags bitmask with explicit boolean
fields. Basically, they untangle the current locking mess so I can
implement the real fix without breaking anything.

The 4th patch in the series is where the real fix happens. With
the previous refactoring in place, I could safely add a lock to each
mid_q_entry and implement atomic callback execution. This eliminates
the race condition that was causing the leaks.

In summary, my approach to the fix is to use smaller-grained locking to
avoid race conditions. However, during the implementation process,
this approach involves more changes than I initially hoped for. If
there's a simpler or more elegant way to fix this race condition that
I've missed, I'd love to hear about it. I've tried to be thorough in
my analysis, but I know there are folks with more experience in this
codebase who might see a better path.

V1 -> V2:
  - Inline the mid_execute_callback() in the smb2ops.c to eliminate
    the sparse warning.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220404 [1]

Wang Zhaolong (4):
  smb: client: rename server mid_lock to mid_queue_lock
  smb: client: add mid_counter_lock to protect the mid counter counter
  smb: client: smb: client: eliminate mid_flags field
  smb: client: fix mid_q_entry memleak leak with per-mid locking

 fs/smb/client/cifs_debug.c    | 12 ++++--
 fs/smb/client/cifsglob.h      | 22 ++++++-----
 fs/smb/client/connect.c       | 57 +++++++++++++++++----------
 fs/smb/client/smb1ops.c       | 23 +++++++----
 fs/smb/client/smb2ops.c       | 72 +++++++++++++++++++----------------
 fs/smb/client/smb2transport.c |  5 ++-
 fs/smb/client/transport.c     | 71 ++++++++++++++++++----------------
 7 files changed, 152 insertions(+), 110 deletions(-)

-- 
2.39.2

