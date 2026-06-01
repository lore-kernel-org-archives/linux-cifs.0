Received: from mailhub11-fb.kaspersky-labs.com (mailhub11-fb.kaspersky-labs.com [81.19.104.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A827367B8D
	for <linux-cifs@vger.kernel.org>; Mon,  1 Jun 2026 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.104.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305084; cv=none; b=QWcRz9FuE2NunNe1yE43aXzYH9ZLhKzgwFqklljXpFOFZhOTgJOpm93PV7WNfbruUchTAROgQZvgT9YIh0siXLNh3IQi3/fr8E8Jq723ow6gOFXbYyDXrHaB73Zm70FL9bdwcE5/jRPQrdhIe96obdJwU1WZLLxugLdBEdSxTGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305084; c=relaxed/simple;
	bh=sndqFT69Yie3HLAdysICKLP0RzstWHWyo1RrvyvcM/c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XyRFqKx1EjzIBV0kewQlg/9PlotCrCP6izgPqCtgO9bckm/OOR1vMs5qX6dldfAnId6oUul3BInZRDPb6kvMKJmKjGu6rEE88jrNGuB/CbDaIGm4cdjg1/wgCZBJ0RiwvW27qbhJvdcHmMIrd8kqd0mOJjy+lBGpq940aklvhJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com; spf=pass smtp.mailfrom=kaspersky.com; dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b=PJgFVRFa; dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b=fOvlDYfn; arc=none smtp.client-ip=81.19.104.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaspersky.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b="PJgFVRFa";
	dkim=pass (2048-bit key) header.d=kaspersky.com header.i=@kaspersky.com header.b="fOvlDYfn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
	s=mail202505; t=1780304586;
	bh=NOc5JCWhyVDuj/HYL2FzCIUsZfD/xQe2KJGcbHo288w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=PJgFVRFao+gA5PBs0eDhsF7TR7z/a4Eu9W5ZN9b6O0W7xbI5+kZumhNCQ+aRxE0eb
	 evgOcgKPRY+6LUclubTq/+UKJ27iqHazuDxXsvZ6rHaL3e7XfasGyRv6WQQRD7L97G
	 xGyDTTL17RvBIvnvJ9SKqMF5AXf9SpGTVVG+cuuZLFGQeXZPDTcA2uV3UHCVAcl+me
	 K4Oz+ySpirmv9/yHkbwyFb+ELwkKDJLhGuB1000bikfEVIZRfRqyswfm3e8wHMQijw
	 Np7LeSv8wdkHZpnKaNwMvoWGauTIAK45FzwKjQpeDSJqFNIBRQ2lrII/vI9SBCjtr5
	 x90dCAQkX4pHg==
Received: from mailhub11-fb.kaspersky-labs.com (localhost [127.0.0.1])
	by mailhub11-fb.kaspersky-labs.com (Postfix) with ESMTP id B9BF7E8470E
	for <linux-cifs@vger.kernel.org>; Mon,  1 Jun 2026 12:03:06 +0300 (MSK)
Received: from mx9-hwi.kaspersky-labs.com (mx9-hwi.kaspersky-labs.com [101.46.44.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "mx9-hwi.kaspersky-labs.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
	by mailhub11-fb.kaspersky-labs.com (Postfix) with ESMTPS id 8E6C7E838DF
	for <linux-cifs@vger.kernel.org>; Mon,  1 Jun 2026 12:03:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
	s=mail202505; t=1780304578;
	bh=NOc5JCWhyVDuj/HYL2FzCIUsZfD/xQe2KJGcbHo288w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fOvlDYfnsZOWBVssn1tSV4VDTpRs1A6O7M/Q5Q4wPJfQ4yrGlmFiyVuFoAn0xFMND
	 jiS48ng94eyivLf6fWJM52gOvX/Q4qROG+T0H73QhPw+Wso7M+S9UwSGb5aGN3OyCf
	 u7ipeob1mfh1UvbHqYTG9AQWzZktdizNMr8xGf+XqcskWidU0CWSrRdZ0Xjb3cYOyC
	 qpIsmMJ1clWEJHCmpF1w3s0Y4+vhtyYlq5llPXcuAlWpnkaCco0fdW3kL1IJSnUhP6
	 DdvqyoUrt+YjS6TRB8XhZkILZs6RFqORj2ojA4lbFJYfdqrR3jYSpGe+XZH3j/QOC1
	 lbN+yxwBOZ2zA==
Received: from relay9-hwi.kaspersky-labs.com (localhost [127.0.0.1])
	by relay9-hwi.kaspersky-labs.com (Postfix) with ESMTP id A829F1E0AE0;
	Mon,  1 Jun 2026 12:02:58 +0300 (MSK)
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
	by mailhub9-hwi.kaspersky-labs.com (Postfix) with ESMTPS id 1E6AF1E0511;
	Mon,  1 Jun 2026 12:02:58 +0300 (MSK)
Received: from Votokina.avp.ru (10.16.104.187) by HQMAILSRV2.avp.ru
 (10.64.57.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 1 Jun
 2026 12:02:56 +0300
From: Votokina Victoria <Victoria.Votokina@kaspersky.com>
To: <lvc-project@linuxtesting.org>
CC: Victoria Votokina <Victoria.Votokina@kaspersky.com>, Namjae Jeon
	<linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <stable@kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Mon, 1 Jun 2026 12:02:43 +0300
Message-ID: <20260601090245.2320576-1-Victoria.Votokina@kaspersky.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HQMAILSRV4.avp.ru (10.64.57.54) To HQMAILSRV2.avp.ru
 (10.64.57.52)
X-KSE-ServerInfo: HQMAILSRV2.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 06/01/2026 08:51:38
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 203553 [Jun 01 2026]
X-KSE-AntiSpam-Info: Version: 6.1.1.22
X-KSE-AntiSpam-Info: Envelope from: Victoria.Votokina@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 106 0.3.106
 c186c08bf7cde5e9213ea0cefd1fac47a114044f
X-KSE-AntiSpam-Info: {date_rfc_vio_soft_silent}
X-KSE-AntiSpam-Info: {Tracking_cluster_exceptions}
X-KSE-AntiSpam-Info: {Tracking_real_kaspersky_domains}
X-KSE-AntiSpam-Info: {Tracking_black_eng_exceptions}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:5.0.1,7.1.1;127.0.0.199:7.1.2;Votokina.avp.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Tracking_white_helo}
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/01/2026 08:53:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 6/1/2026 8:09:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/06/01 07:57:00 #28206513
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 52

From: Victoria Votokina <Victoria.Votokina@kaspersky.com>

commit 66751841212c2cc196577453c37f7774ff363f02 upstream.

smb2_get_ea() reads ea_req->EaNameLength from the client request and
passes it directly to strncmp() as the comparison length without
verifying that the length of the name really is the size of the input
buffer received.

Fix this up by properly checking the size of the name based on the value
received and the overall size of the request, to prevent a later
strncmp() call to use the length as a "trusted" size of the buffer.
Without this check, uninitialized heap values might be slowly leaked to
the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Victoria Votokina <Victoria.Votokina@kaspersky.com>
---
Backport fix for CVE-2026-31612
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a2bb3461d65e..3574bb82fe72 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4390,6 +4390,11 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 		ea_req = (struct smb2_ea_info_req *)((char *)req +
 						     le16_to_cpu(req->InputBufferOffset));
+
+		if (le32_to_cpu(req->InputBufferLength) <
+		    offsetof(struct smb2_ea_info_req, name) +
+		    ea_req->EaNameLength)
+			return -EINVAL;
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
 		if (le32_to_cpu(req->Flags) & SL_RETURN_SINGLE_ENTRY)
-- 
2.43.0

