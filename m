Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AAD30F52D
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771249750; cv=none; b=Ho8RU5QIHsOjLs+wuLgjZMQI4cUyqfedELgzHcOmxlWvPyQS5HXYFQtvAiEUyhzJ8I99n0yeO6Byyx9E6VGLE5OdjCD1K/S6v4NriFtHosEQ/YkLwz9NwsHlbfMMhlmWfv/3zjrb77fgvnCpTFChPbZDWQX5+m9WT00btvoK6Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771249750; c=relaxed/simple;
	bh=QXkJeGGgTM5kTJHwEagxaNWgnCB7mD8hbzjRr+MMY2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQ7kzt4wmFuvKrN0ff66gJbGwbgkmCOPB3PKqNft9jdgHMuHZbtRGoHFIs/htBBGOOyKeLM7G5rWZ2sGkianky+mq7TYVoptrWvHAh8FfjKNMm3nxbdCMmKaXCD9t54j10eaUDrpxEa+vB02bHxyI6AK5GHEpI8+avvhs9zqm/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0AV5Wmap; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0AV5Wmap"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=zd6IMtBaFqOFhEm49qGRT6pVNelp+zD8kq2SXFNRaNM=; b=0AV5WmapO46pvMDCY5iI/o04nP
	scthogVEFzFHdzd3i/OaGFjhnVjLCNJz+9vT99WlDWZcCFrLHLPj0mnAHfcyYntIbu3aReYcVv89U
	bTf3t8DTVvNIWUma/lbQulmywtUZMsZmQIZwrDGG/eM8CIZ2cGdTns54qBLRuZf1Hd3YxUnZTfkC+
	jEhD+cbwRsmdL6TNZ+Zz1J6OFcmdj8k4wovTpUGeBjzjKm6EyvFvRf6J8TjvKDgg9LV6fyufa3H3Y
	/C73+jDwriXJBgfND25WmNdkzDRDvDUAAT7HvT/bGo3rbno0Mmf/ptsbkDvlHtgwRNYu0GirOutt8
	+O5svlZS+w4rzZEaYmlHozhM4kS7MvQhwlB2OmBSACbUHKabgO9YFcy3JqhjkrQzkS2FA0gY9leF9
	HsYZOQX8KBcpRtCvCCvwkjhanprhEq3NKteMjRBIqbnbU4xRcb+KlL4RuCiKpLotlbG3Mnzz2F7ic
	iU+X1jojOAdF3P8TK2uRV4QW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vryyH-00000006c0b-2MAT;
	Mon, 16 Feb 2026 13:49:05 +0000
Message-ID: <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org>
Date: Mon, 16 Feb 2026 14:49:05 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Arnd Bergmann <arnd@kernel.org>
References: <cover.1770311507.git.metze@samba.org>
 <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org>
 <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
 <CAH2r5muf=Th_AbA7SZaQKApyvr81FMB8WF-5yZ3ihzap1swQWg@mail.gmail.com>
 <98d25ce1-1f1a-4517-89f0-8956bffaf9d3@samba.org>
 <CAH2r5mswN8W652Br4QQTzhtDXtXKvqea=dWVfUFF+xDYfOx6HA@mail.gmail.com>
 <28d94c9f-b85e-4746-bb08-188090409682@samba.org>
 <CAH2r5mtA=DdpEiyqspNG3eoyjkGajnEwoRnOyXyBimDtCND9ig@mail.gmail.com>
 <c5aef237-2a12-4be5-b917-de502780be85@samba.org>
 <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

for-7.0/smbdirect-ko-20260216-v8 at commit:
8a2259252f084fe55411346d58a1160fc69b7d30
git fetch https://git.samba.org/metze/linux/wip.git for-7.0/smbdirect-ko-20260216-v8
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.0/smbdirect-ko-20260216-v8

fixes 3 problems:
compared to for-7.0/smbdirect-ko-20260213-v7:

- We use BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));
   instead of BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
   Closes: https://lore.kernel.org/oe-kbuild-all/202602141417.hsmt2AAb-lkp@intel.com/
- We now use [SMBDIRECT_DEBUG_]ERR_PTR(ret) with %1pe
   instead of errname(ret) with %s
   Closes: https://lore.kernel.org/oe-kbuild-all/202602141435.Sm9ZppiO-lkp@intel.com/
- We use 'select SG_POOL' for the client as long
   as smbdirect_all_c_files.c is used
   Closes: https://lore.kernel.org/linux-cifs/20260216105404.2381695-1-arnd@kernel.org/

The overall diff to the current ksmbd-for-next
(at commit 2a43d1cf4bd3bc0cff03f0926e83895a7462ad05) is pasted below:

Please replace ksmbd-for-next with commit
8a2259252f084fe55411346d58a1160fc69b7d30,

Thanks!
metze

  fs/smb/client/smbdirect.c                      |  5 ++---
  fs/smb/common/smbdirect/smbdirect_connection.c | 26 +++++++++++++-------------
  fs/smb/common/smbdirect/smbdirect_devices.c    |  3 ++-
  fs/smb/common/smbdirect/smbdirect_internal.h   |  1 -
  fs/smb/common/smbdirect/smbdirect_main.c       |  3 ++-
  fs/smb/common/smbdirect/smbdirect_mr.c         | 21 +++++++++++----------
  fs/smb/common/smbdirect/smbdirect_socket.c     |  3 ++-
  fs/smb/server/transport_rdma.c                 | 25 ++++++++++++-------------
  8 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index de3b51fa2d62..ff80072dc9ff 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -5,7 +5,6 @@
   *   Author(s): Long Li <longli@microsoft.com>
   */

-#include <linux/errname.h>
  #include "smbdirect.h"
  #include "cifs_debug.h"
  #include "cifsproto.h"
@@ -325,8 +324,8 @@ static struct smbd_connection *_smbd_get_connection(

  	ret = smbdirect_connect_sync(sc, dstaddr);
  	if (ret) {
-		log_rdma_event(ERR, "connect to %pISpsfc failed: %s\n",
-			       dstaddr, errname(ret));
+		log_rdma_event(ERR, "connect to %pISpsfc failed: %1pe\n",
+			       dstaddr, ERR_PTR(ret));
  		goto connect_failed;
  	}

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 813ddd87c6ae..1e946f78e935 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -968,7 +968,7 @@ smbdirect_init_send_batch_storage(struct smbdirect_send_batch_storage *storage,
  	struct smbdirect_send_batch *batch = (struct smbdirect_send_batch *)storage;

  	memset(storage, 0, sizeof(*storage));
-	BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
+	BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));

  	smbdirect_connection_send_batch_init(batch,
  					     need_invalidate_rkey,
@@ -1111,10 +1111,10 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,

  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
  		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
-			"status=%s first_error=%1pe => %s\n",
+			"status=%s first_error=%1pe => %1pe\n",
  			smbdirect_socket_status_string(sc->status),
  			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
-			errname(-ENOTCONN));
+			SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
  		return -ENOTCONN;
  	}

@@ -1273,10 +1273,10 @@ int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
  		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
  		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
-			"status=%s first_error=%1pe => %s\n",
+			"status=%s first_error=%1pe => %1pe\n",
  			smbdirect_socket_status_string(sc->status),
  			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
-			errname(-ENOTCONN));
+			SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
  		return -ENOTCONN;
  	}

@@ -1305,10 +1305,10 @@ int smbdirect_connection_send_iter(struct smbdirect_socket *sc,

  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
  		smbdirect_log_write(sc, SMBDIRECT_LOG_INFO,
-			"status=%s first_error=%1pe => %s\n",
+			"status=%s first_error=%1pe => %1pe\n",
  			smbdirect_socket_status_string(sc->status),
  			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
-			errname(-ENOTCONN));
+			SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
  		return -ENOTCONN;
  	}

@@ -1485,8 +1485,8 @@ int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
  	ret = ib_post_recv(sc->ib.qp, &recv_wr, NULL);
  	if (ret) {
  		smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
-			"ib_post_recv failed ret=%d (%s)\n",
-			ret, errname(ret));
+			"ib_post_recv failed ret=%d (%1pe)\n",
+			ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  		ib_dma_unmap_single(sc->ib.dev,
  				    msg->sge.addr,
  				    msg->sge.length,
@@ -1716,8 +1716,8 @@ int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
  		ret = smbdirect_connection_post_recv_io(recv_io);
  		if (ret) {
  			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
-				"smbdirect_connection_post_recv_io failed rc=%d (%s)\n",
-				ret, errname(ret));
+				"smbdirect_connection_post_recv_io failed rc=%d (%1pe)\n",
+				ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  			smbdirect_connection_put_recv_io(recv_io);
  			return ret;
  		}
@@ -1802,10 +1802,10 @@ int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
  again:
  	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
  		smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
-			"status=%s first_error=%1pe => %s\n",
+			"status=%s first_error=%1pe => %1pe\n",
  			smbdirect_socket_status_string(sc->status),
  			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
-			errname(-ENOTCONN));
+			SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
  		return -ENOTCONN;
  	}

diff --git a/fs/smb/common/smbdirect/smbdirect_devices.c b/fs/smb/common/smbdirect/smbdirect_devices.c
index d1a251141145..3ace41af2200 100644
--- a/fs/smb/common/smbdirect/smbdirect_devices.c
+++ b/fs/smb/common/smbdirect/smbdirect_devices.c
@@ -249,7 +249,8 @@ __init int smbdirect_devices_init(void)

  	ret = ib_register_client(&smbdirect_ib_client);
  	if (ret) {
-		pr_err("failed to ib_register_client: %d %s\n", ret, errname(ret));
+		pr_crit("failed to ib_register_client: %d %1pe\n",
+			ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  		return ret;
  	}

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 09a4ce8ed863..30a1b8643657 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -8,7 +8,6 @@

  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

-#include <linux/errname.h>
  #include "smbdirect.h"
  #include "smbdirect_pdu.h"
  #include "smbdirect_public.h"
diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/smbdirect/smbdirect_main.c
index 266d00da25f6..fe6e8d93c34c 100644
--- a/fs/smb/common/smbdirect/smbdirect_main.c
+++ b/fs/smb/common/smbdirect/smbdirect_main.c
@@ -91,7 +91,8 @@ static __init int smbdirect_module_init(void)
  	destroy_workqueue(smbdirect_globals.workqueues.accept);
  alloc_accept_wq_failed:
  	mutex_unlock(&smbdirect_globals.mutex);
-	pr_crit("failed to loaded: %d (%s)\n", ret, errname(ret));
+	pr_crit("failed to loaded: %d (%1pe)\n",
+		ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  	return ret;
  }

diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index 5e9420d01fe3..32668c58efb0 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -43,8 +43,9 @@ int smbdirect_connection_create_mr_list(struct smbdirect_socket *sc)
  		if (IS_ERR(mr->mr)) {
  			ret = PTR_ERR(mr->mr);
  			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-				"ib_alloc_mr failed ret=%d (%s) type=0x%x max_frmr_depth=%u\n",
-				ret, errname(ret), sc->mr_io.type, sp->max_frmr_depth);
+				"ib_alloc_mr failed ret=%d (%1pe) type=0x%x max_frmr_depth=%u\n",
+				ret, SMBDIRECT_DEBUG_ERR_PTR(ret),
+				sc->mr_io.type, sp->max_frmr_depth);
  			goto ib_alloc_mr_failed;
  		}
  		mr->sgt.sgl = kcalloc(sp->max_frmr_depth,
@@ -173,8 +174,8 @@ smbdirect_connection_get_mr_io(struct smbdirect_socket *sc)
  				       sc->status != SMBDIRECT_SOCKET_CONNECTED);
  	if (ret) {
  		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"wait_event_interruptible ret=%d (%s)\n",
-			ret, errname(ret));
+			"wait_event_interruptible ret=%d (%1pe)\n",
+			ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  		return NULL;
  	}

@@ -304,8 +305,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
  	ret = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
  	if (!ret) {
  		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"ib_dma_map_sg num_pages=%u dir=%x ret=%d (%s)\n",
-			num_pages, mr->dir, ret, errname(ret));
+			"ib_dma_map_sg num_pages=%u dir=%x ret=%d (%1pe)\n",
+			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  		goto dma_map_error;
  	}

@@ -348,8 +349,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
  	}

  	smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-		"ib_post_send failed ret=%d (%s) reg_wr->key=0x%x\n",
-		ret, errname(ret), reg_wr->key);
+		"ib_post_send failed ret=%d (%1pe) reg_wr->key=0x%x\n",
+		ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);

  map_mr_error:
  	ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
@@ -435,8 +436,8 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
  		ret = ib_post_send(sc->ib.qp, wr, NULL);
  		if (ret) {
  			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-				"ib_post_send failed ret=%d (%s)\n",
-				ret, errname(ret));
+				"ib_post_send failed ret=%d (%1pe)\n",
+				ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
  			smbdirect_mr_io_disable_locked(mr);
  			smbdirect_socket_schedule_cleanup(sc, ret);
  			goto done;
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 073df565f347..74e31b35a2f6 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -71,7 +71,8 @@ int smbdirect_socket_init_new(struct net *net, struct smbdirect_socket *sc)
  	ret = rdma_set_afonly(id, 1);
  	if (ret) {
  		rdma_destroy_id(id);
-		pr_err("%s: rdma_set_afonly() failed %1pe\n", __func__, errname(ret));
+		pr_err("%s: rdma_set_afonly() failed %1pe\n",
+		       __func__, SMBDIRECT_DEBUG_ERR_PTR(ret));
  		return ret;
  	}

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5a577a9b0bf8..706a2c897948 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -12,7 +12,6 @@
  #include <linux/kthread.h>
  #include <linux/list.h>
  #include <linux/string_choices.h>
-#include <linux/errname.h>

  #include "glob.h"
  #include "connection.h"
@@ -413,8 +412,8 @@ static int smb_direct_listen(struct smb_direct_listener *listener,

  	ret = smbdirect_socket_create_kern(net, &sc);
  	if (ret) {
-		pr_err("smbdirect_socket_create_kern() failed: %d %s\n",
-		       ret, errname(ret));
+		pr_err("smbdirect_socket_create_kern() failed: %d %1pe\n",
+		       ret, ERR_PTR(ret));
  		return ret;
  	}

@@ -440,28 +439,28 @@ static int smb_direct_listen(struct smb_direct_listener *listener,
  				     smb_direct_logging_vaprintf);
  	ret = smbdirect_socket_set_initial_parameters(sc, sp);
  	if (ret) {
-		pr_err("Failed smbdirect_socket_set_initial_parameters(): %d %s\n",
-		       ret, errname(ret));
+		pr_err("Failed smbdirect_socket_set_initial_parameters(): %d %1pe\n",
+		       ret, ERR_PTR(ret));
  		goto err;
  	}
  	ret = smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQUEUE, KSMBD_DEFAULT_GFP);
  	if (ret) {
-		pr_err("Failed smbdirect_socket_set_kernel_settings(): %d %s\n",
-		       ret, errname(ret));
+		pr_err("Failed smbdirect_socket_set_kernel_settings(): %d %1pe\n",
+		       ret, ERR_PTR(ret));
  		goto err;
  	}

  	ret = smbdirect_socket_bind(sc, (struct sockaddr *)&sin);
  	if (ret) {
-		pr_err("smbdirect_socket_bind() failed: %d %s\n",
-		       ret, errname(ret));
+		pr_err("smbdirect_socket_bind() failed: %d %1pe\n",
+		       ret, ERR_PTR(ret));
  		goto err;
  	}

  	ret = smbdirect_socket_listen(sc, 10);
  	if (ret) {
-		pr_err("Port[%d] smbdirect_socket_listen() failed: %d %s\n",
-		       port, ret, errname(ret));
+		pr_err("Port[%d] smbdirect_socket_listen() failed: %d %1pe\n",
+		       port, ret, ERR_PTR(ret));
  		goto err;
  	}

@@ -473,8 +472,8 @@ static int smb_direct_listen(struct smb_direct_listener *listener,
  			      "ksmbd-smbdirect-listener-%u", port);
  	if (IS_ERR(kthread)) {
  		ret = PTR_ERR(kthread);
-		pr_err("Can't start ksmbd listen kthread: %d %s\n",
-		       ret, errname(ret));
+		pr_err("Can't start ksmbd listen kthread: %d %1pe\n",
+		       ret, ERR_PTR(ret));
  		goto err;
  	}


