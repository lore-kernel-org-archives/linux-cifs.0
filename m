Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2001A08A3
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757531129; cv=none; b=TLtXfut06zyRWUPjihSZLkDhtPqP+g8aQohfr/dwCaNKGHRmpEmb5Dm1oa70sc4W5XQ9Q4/LaZ2bJKHj0Vp35cP7P+qlOYH5vi6WtAT7tar8n7lkhLgmh4ibEtg1Gwi1P44aovpsp6CauO7k/asf88ceZLOfLtpi3TlvUYOuNbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757531129; c=relaxed/simple;
	bh=zvVFgUtG2PYlbQf5kGEZfIscAX6V6qnDUqHoTPEhSZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8Jjxmgbt1/6faVjaH/YtDQV6x6IDP+XyVHwEQDUc7N1/WPVQaI/iJLxqnhcF0TkxVaDw8kyDRIT9JqBCs3d6mV1SJMdXvZrvR+1fyglR9f1pS3o5Ud86lcG2JCldeyfPPfyI6yasPxNKcV04dzI7Opv8iHwKJSe1JpCs4Ba+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gWXrCIrt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gWXrCIrt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=YiL6GulIFr+mlSqJ4d1AWNF4hfFaAl0s8YiAXyR4kBI=; b=gWXrCIrtduAE1K1h0BVyS6jHHO
	rbFiZ16lsPABQKXHbs45oAVZt1kQhaxuvFIJhqJQ4WrqEaSzTo3v4VqXxfWy1N5pdiBpJYEh/KTOe
	QrIBqXYKCkpEMCDyB3C5iy44yQ09vrPuLr1EQG3+RHm65wSrdJ0JYkWT5hi3UcHfMDGoFEAKXAmZH
	fW+pYnQ3WY+jNlrL5DN/ffBSJuoi1E78BIVmBWzqqd+E0+nBMA8TdO+WMw3d0uxnuG+Agp/N9b6M3
	KXgQ4fRLLtUxXZGCaAn+AehvtsqXZQjNg8lp6H7uTb/El3HtElqIwgeSLlkH8mXf8045WRukZdoPN
	rqVPGjipalCvMY5O0CKeDDa8oDOa78MUSQaYYIXMzx+2HYEAWDWHpkYAc5pz18B/qavKV3gNuAcbc
	Ohh08L8DYrAvSFSc4lBDyykc3q8PVhPxBMvtRLUSvIjZTpcPJRRsPu18FGSbDPhfOgQOgCSdlM/Ov
	HeEQxXc8PR6rV7uiqLYgIGH/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uwQ87-003TWY-0V;
	Wed, 10 Sep 2025 19:05:19 +0000
Message-ID: <642872f4-e076-4588-b011-920479b06949@samba.org>
Date: Wed, 10 Sep 2025 21:05:17 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: replace for-next-next... Re: [PATCH v4 000/142] smb:
 smbdirect/client/server: make use of common structures
To: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1756139607.git.metze@samba.org>
 <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
 <CAH2r5msKSbUfOVXUabNQep3s2H4kW0AMnDh0XA68Pk3_oqaHCQ@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5msKSbUfOVXUabNQep3s2H4kW0AMnDh0XA68Pk3_oqaHCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve, hi Namjae,

I found "ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer"
https://git.samba.org/?p=ksmbd.git;a=commitdiff;h=927f8fe05e334d016c598d2cc965161c2808d9ba
in ksmbd-for-next-next.

I added a Fixes and Reviewed-by tag
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=fa36db4e8d62aa9c3ba1200323d8e01e4eb88b19
and two additional patches:
ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=9e881174900e53dd2b17c0c0933cc4395ceb47a6
smb: client: let recv_done verify data_offset, data_length and remaining_data_length
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=174faeea9ee496b724206d405b74db8b05729f11

I think these should go into 6.17.

As there as conflicts with for-next-next I rebased it again
and made sure each commit compiles and the result still passes
the tests I made last time.

The result can be found under
git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-20250910-v6
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-6.18/fs-smb-20250910-v6

Please have a look and replace for-next-next again...
The diff against the current for-next-next (e2e99af785ee91ce20c6d583e396660494db77a2)
and for-6.18/fs-smb-20250910-v6 (1fb2a52741e836f54a4691cbd74d9d70d736e506) follows below.

Thanks!
metze

  fs/smb/client/smbdirect.c                  | 19 ++++++++++++++++++-
  fs/smb/common/smbdirect/smbdirect_socket.h |  2 +-
  fs/smb/server/transport_rdma.c             | 25 +++++++++++++++++--------
  3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 322334097e30..6215a6e91c67 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -548,7 +548,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
  	struct smbdirect_socket *sc = response->socket;
  	struct smbdirect_socket_parameters *sp = &sc->parameters;
  	u16 old_recv_credit_target;
-	int data_length = 0;
+	u32 data_offset = 0;
+	u32 data_length = 0;
+	u32 remaining_data_length = 0;
  	bool negotiate_done = false;

  	log_rdma_recv(INFO,
@@ -600,7 +602,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
  	/* SMBD data transfer packet */
  	case SMBDIRECT_EXPECT_DATA_TRANSFER:
  		data_transfer = smbdirect_recv_io_payload(response);
+
+		if (wc->byte_len <
+		    offsetof(struct smbdirect_data_transfer, padding))
+			goto error;
+
+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
+		data_offset = le32_to_cpu(data_transfer->data_offset);
  		data_length = le32_to_cpu(data_transfer->data_length);
+		if (wc->byte_len < data_offset ||
+		    wc->byte_len < (u64)data_offset + data_length)
+			goto error;
+
+		if (remaining_data_length > sp->max_fragmented_recv_size ||
+		    data_length > sp->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length > (u64)sp->max_fragmented_recv_size)
+			goto error;

  		if (data_length) {
  			if (sc->recv_io.reassembly.full_packet_received)
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 8542de12002a..91eb02fb1600 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -63,7 +63,7 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
  	case SMBDIRECT_SOCKET_DISCONNECTING:
  		return "DISCONNECTING";
  	case SMBDIRECT_SOCKET_DISCONNECTED:
-		return "DISCONNECTED,";
+		return "DISCONNECTED";
  	case SMBDIRECT_SOCKET_DESTROYED:
  		return "DESTROYED";
  	}
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 33d2f5bdb827..e371d8f4c80b 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -538,7 +538,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
  	case SMBDIRECT_EXPECT_DATA_TRANSFER: {
  		struct smbdirect_data_transfer *data_transfer =
  			(struct smbdirect_data_transfer *)recvmsg->packet;
-		unsigned int data_length;
+		u32 remaining_data_length, data_offset, data_length;
  		u16 old_recv_credit_target;

  		if (wc->byte_len <
@@ -548,15 +548,24 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
  			return;
  		}

+		remaining_data_length = le32_to_cpu(data_transfer->remaining_data_length);
  		data_length = le32_to_cpu(data_transfer->data_length);
-		if (data_length) {
-			if (wc->byte_len < sizeof(struct smbdirect_data_transfer) +
-			    (u64)data_length) {
-				put_recvmsg(sc, recvmsg);
-				smb_direct_disconnect_rdma_connection(sc);
-				return;
-			}
+		data_offset = le32_to_cpu(data_transfer->data_offset);
+		if (wc->byte_len < data_offset ||
+		    wc->byte_len < (u64)data_offset + data_length) {
+			put_recvmsg(sc, recvmsg);
+			smb_direct_disconnect_rdma_connection(sc);
+			return;
+		}
+		if (remaining_data_length > sp->max_fragmented_recv_size ||
+		    data_length > sp->max_fragmented_recv_size ||
+		    (u64)remaining_data_length + (u64)data_length > (u64)sp->max_fragmented_recv_size) {
+			put_recvmsg(sc, recvmsg);
+			smb_direct_disconnect_rdma_connection(sc);
+			return;
+		}

+		if (data_length) {
  			if (sc->recv_io.reassembly.full_packet_received)
  				recvmsg->first_segment = true;




