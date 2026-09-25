Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9303BCD29
	for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 20:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367619; cv=none; b=VYZlgF5pxe1JvFaJtVcOp0jryu7ypjo0IRVvJlKNZBh5r/UX5wSxig175aiv8u8opSZrBSMSE/A6LNnRmodWfqTA9RWg3pMUGFOGHByr398712NRcwgm7VZXLDpoPD/3eQAMo0H26JCQ1HLhs3mar/PBEv9hTSmRH0JkJQtaTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367619; c=relaxed/simple;
	bh=YXv3JrHgcesu4Cy1YbyHFO7NojEvHitwS8x2fQJE+zE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xwpp6Dg9RA8n+6spBGxot1i4fpbN/3zUBNG0CzegDI1io9OjgiBrEPrRqEzJCTPOcgOTO+/pejiIY76xXiua52yuYge8bWeqrQ8ZcXVislGSBP5Mb257yzxidR6dtpXAf6OtRYrwxrGhNqwHdbL4Pmt2OkgzydeEzWilZr5O8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=h6GQ8Bnt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oXLosKJq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EYNIko5h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tk8axG6L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="h6GQ8Bnt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oXLosKJq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EYNIko5h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tk8axG6L"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF85D1F388;
	Fri, 25 Sep 2026 20:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ame0EeThykAI7JORnTWfbj7GiweP6s99/hlwKdP7NRg=;
	b=h6GQ8BntoUka0OHaidKeatbA6PEgtmbDsFzbocllRSEsOnI+4K91mb3SdHt17B0DyWjcmw
	btVYUK3sTnqeipRFMspw7uVkxWBYg21Sfu7TKlex1XoaSAPmt0WEb36wAV/GxALntZSmac
	EhFz/JvyIxD9QiN2XCfhXfi4JiUk8DM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ame0EeThykAI7JORnTWfbj7GiweP6s99/hlwKdP7NRg=;
	b=oXLosKJq6sX/6svXUVlGink8OuLePtuNzdt8g8kq2Hj1Kmro+68hR5Zo5QzTsAaEQjjNfu
	thRSWelZgmXWbLCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EYNIko5h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Tk8axG6L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790367607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ame0EeThykAI7JORnTWfbj7GiweP6s99/hlwKdP7NRg=;
	b=EYNIko5h+Qk2Kd5TvscLAhrpugKguc71VK5h0BiO7PdHexKDfY3B9LYsl8QtSea/6EhvUU
	gCcMslGli7wILOh8stMxqC06p/iJ61gNM/m8PqQ90PPyJUmLq1Xe7UQV+oohaLjAFY7s6h
	HkAhpUaue4YAqOust3nF+llQDuqWMu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790367607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ame0EeThykAI7JORnTWfbj7GiweP6s99/hlwKdP7NRg=;
	b=Tk8axG6LULwHvOG0oS0W/p6juMUvKf6Neqt+nmfacmtT4AGiOOc1AaLelOMGTyD1Fubb3j
	bEzzYYBIPK7kBBBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C1BF13274;
	Fri, 25 Sep 2026 20:20:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WlN2L3bXtmo9XQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 25 Sep 2026 20:20:07 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 0/2] reconnect fixes and improvements
Date: Fri, 25 Sep 2026 17:20:01 -0300
Message-ID: <20260925202003.618856-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CF85D1F388
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,writer.py:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Hi all,

(sending a cover letter to keep commit messages smaller)

This series addresses 2 problems:

1)
cifs_reconnect() races with other tasks to acquire server mutex,
so reconnect process is delayed when there are many tasks.

(some tests showed cifs_reconnect() waiting >1h to acquire the mutex,
which is beyond absurd)

When a non-cifsd task sets CifsNeedReconnect
(cifs_signal_cifsd_for_reconnect()), it can take a varying amount of
time to cifs_reconnect() to actually run.

cifs_reconnect() only gets to run after all the other tasks in the
mutex wait queue fail/timeout their ops (and then release the mutex).

Also, tasks that enter the send path after CifsNeedReconnect is set
will wait on cifs_wait_for_server_reconnect() for up to 10s for
reconnect to happen.  It's clearly not enough given that
cifs_reconnect() might not even have started yet.


2)
Requests are discarded because server was prematurely considered down.

cifs_wait_for_server_reconnect() should only wait for reconnect, and
not determine if server is down (not its job).

Furthermore, it returns -EHOSTDOWN when wait times out, which is not
replayable, thus requests are discarded (lost).


Fix:
Since there's no proper bug (hang, crash, etc) to fix, the patches
fixes reconnect behavior:
- clear up the send path if there's a need to reconnect (fast fail)
- make cifs_wait_for_server_reconnect() wait for cifs_reconnect() to
  start before waiting for a tcpStatus change
- if cifs_wait_for_server_reconnect() times out, but cifs_reconnect()
  is still trying, allow callers to retry (-EAGAIN vs -EHOSTDOWN)


Reproducer (writer.py at the end):

  # mount.cifs -o ... //srv/share /mnt
  # for i in $(seq 1 20); do ( python3 writer.py /mnt $i & ) ; done
  # echo_interval=$(mount -t cifs | grep -Po '(?<=echo_interval=)[^,]+')
  # ip_addr=$(mount -t cifs | grep -Po '(?<=addr=)[^,]+')
  # while true \
  do \
  sleep $((echo_interval * 2)) \
  iptables -A OUTPUT -d $ip_addr -p tcp --dport 445 -j DROP \
  sleep $((echo_interval * 3)) \
  iptables -D OUTPUT -d $ip_addr -p tcp --dport 445 -j DROP \
  done

About ~15s after the first drop, dmesg starts showing (added task
comm/pid for demonstration purposes):
  ...
  [81802.584463] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[27248])
  [81817.943889] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[26744])
  [81833.303344] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[27239])
  [81848.662748] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[26738])
  [81864.022183] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[27131])
  [81879.381663] CIFS: VFS: \\w25.vm.test sends on sock 00000000462438e7 stuck for 15 seconds (task python3[27280])
  ...

During this particular test, there were 159 other 'python3' tasks
already waiting for the mutex by the time cifs_abort_connection()
tried to acquire it.

i.e. cifs_reconnect() only ran after ~40min!
Obviously, hung task detector is triggered, if enabled.


Cheers,

Enzo


---- writer.py begin ----
from concurrent.futures import ThreadPoolExecutor
import sys
import os

text = "A" * 128 * 100
base_dir = sys.argv[1]
pfx = sys.argv[2]

def create_write_delete_file(i):
    filename = os.path.join(base_dir, f"{pfx}_file_{i}.txt")
    try:
        with open(filename, "w") as f:
            for j in range(1000):
                f.write(f"file: {j}\n")
                f.flush()
                f.write(text)
                f.flush()
                os.fsync(f.fileno())  
        os.remove(filename)
    except Exception as e:
        print(f"error at file: {filename}: {e}")

def main():
    for i in range(5):
        print(f"run: {i}")
        with ThreadPoolExecutor(max_workers=50) as executor:
            executor.map(create_write_delete_file, range(500))

if __name__ == "__main__":
    main()
---- writer.py end ----

Hardcoded for 5 runs of 50 workers, writing 1000 times per file, with
500 files.  YMMV, so might require increasing numbers if you can't
reproduce it.


Enzo Matsumiya (2):
  smb: client: fast fail sends if need to reconnect
  smb: client: prevent premature discard of requests if reconnecting

 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/connect.c   | 35 +++++++++++++----
 fs/smb/client/misc.c      | 83 +++++++++++++++++++++++++--------------
 fs/smb/client/transport.c |  8 ++++
 4 files changed, 89 insertions(+), 38 deletions(-)

-- 
2.55.0

