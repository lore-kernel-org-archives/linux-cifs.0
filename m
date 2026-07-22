Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2713EA962;
	Wed, 22 Jul 2026 04:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784693469; cv=none; b=ONjbMaER+U0/6xyTVA7aUcb8ziye8G1gHzihWvvIvxgKOzv3F+3WUwiLNaEcTTYknaG+FyV6DC0Oh4ETjUK9JFB8eG9H8++/yEV+mA0b/z0WsfxcK2OsyzKlR0gP9fSivIMXU6z/wkGSOPy7EsVsVhyKhtgmxXedZh36Q3U6QXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784693469; c=relaxed/simple;
	bh=B9NdxqKzZg9QVwOErNBbVUnT9LeZgonQFmH+36oHkys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wxi8kWSVsmZXot9pHPhqWCdLTjZMDGI857Vrtxm5N6cNgPKY5Z27WdDiFo7qJaeO896Bhb0bbQO3yB730rFYoun6xUfgsl3KqCNyG2bLEt667XydN7CnWahu1KxKmLY6kOY+UQqB8h7ZUGgPIqKF5lkKwidIKcmtqx1NIO1LWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAAXhT_DQmBq1xC7AA--.23588S2;
	Wed, 22 Jul 2026 12:10:44 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [RFC] smb: client: define async channel update serialization
Date: Wed, 22 Jul 2026 12:10:43 +0800
Message-ID: <20260722041043.90682-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXhT_DQmBq1xC7AA--.23588S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4DAryrKr1rXFWfXry7KFg_yoW8Zw47pF
	WSg3y8Gr1kJrWfA3WkZw40grW8urZ5CF4UJrn8J348Aw45trnFvFW3tw4j9F9rCrs3X3yj
	9r1Ygw4qka1qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUb_Ma5UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

Commit 556bb341f9f2 ("smb: client: introduce multichannel async work
during mount") moved multichannel setup out of the mount path and into
independent work items. Mounts can share an existing session, so more than
one worker can update the same channel array concurrently.

cifs_try_adding_channels() snapshots chan_count and the number of missing
channels under chan_lock, but drops that lock while each channel is opened.
Two workers can therefore act on the same initial count. More importantly,
cifs_ses_add_channel() publishes a new slot before taking session_mutex, and
its failure path later decrements the current chan_count. If another worker
has appended a slot in between, that rollback can remove the wrong tail.
At the array limit, a stale worker can also index chans[chan_count] after
another worker has filled the last slot.

I considered making the mount worker use
CIFS_SES_FLAG_SCALE_CHANNELS, but that flag is not a blocking lock. A worker
that fails to acquire it has no retry or completion to wait on. In addition,
smb2_reconnect() currently clears the flag on a shared exit path even when it
only observed another updater owning it, and an early channel-disable path
runs before the existing flag acquisition.

Extending session_mutex around slot publication and rollback would serialize
concurrent additions, but it does not by itself serialize the reconfigure
decrease path. Conversely, a new mutex around all of
smb3_update_ses_channels() needs an explicit lock order because reconnect can
call channel removal while already holding session_mutex, whereas channel
addition later acquires session_mutex for session setup.

Would you prefer this to be fixed by coalescing mount requests onto one
per-session work item, or by introducing a dedicated channel-update
serialization primitive with an agreed lock order? Once that lifetime and
locking contract is clear, I can prepare a narrow patch and keep the capacity
check at the actual chans[] append as a final invariant.

