Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794571245;
	b=SzseMz7jaX6RhgJgcC9xpHN/Z7i+7r7uAhcu7BdrvVeVSKnS1Lvpl+Ba2mxvo+d8/zo3
	 aIAt6BLVsUBDPoQh2k443dLc9JNlJzXGwtN1Vb4yVTgr/KQrT8JeMU5K/PaF90AjFUEPl
	 0ddPCYbBW52CXT9Wii4xIt/rKJnL18+lMU8e1pRgrwQI5x+GpADGinsMErETGx8Ijpq6P
	 95f3EkJ9dtA5VvPnnkLcxdPJ17fibgBjopSPMWsc3+gDnxT8JPuH4cr6Vn5/Oq5GnPrfQ
	 7cKXO9mCzffRu6NL7z8fCGzJF2AoOVQAScBudzH5GYFBvEriXFjWaRLSO5J0R9MpuQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571245;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=r48ECBIn/ZDjW20r1K8xJKQyd/oDeFIv6pFjVhzh+D0=;
	b=Yg4FREgljRrmwa1R8SJWylW+x2CjctfD0hZlSGvXELr6eb6o6J7cDfB/V5lMsGikt5Ue
	 fdYlHs9OqoNPj5n7qav3C8aBZqwtpEBPpecwrYpi7Op+jTMujtp4C9s+oiKBnCKL7lre5
	 VV4pn1/J3KIl95czlXcuMTkVLBN5K0D8+8V3vX7LiGznGIu6qO7CBnenR9kE1nXIlox3V
	 6RpVy9ivO3CoQDyWc80XzYPD2J24aNJWHcmGIInT8CPCTeRj0b+JgjGt07y2VsJmQh7Pe
	 UP+w4QlZDiYQAI0QnBs/Xd+BQlz163sLeEW5igRvVAazUcgiLcI+Dsjr41LsAMgc13w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKw2rG7N;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9F3606A884;
	Fri, 13 Nov 2026 12:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKw2rG7N
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794571245;
	b=r7D7H54Fy9gKALRBOowWileMoqTeMdUfY99y1/rlcQXrHm6UxtxWVEzBc8S6RsALqzki
	 8DzaCM9lStSqBo+uqIJxdsHyBfNoWYZNu6Hql10O5D7KL6Ud+RH1/xhS45gGbV1pey3XC
	 MIhOpZhLiM5us5zGqUZVHrOFQmAVwudxeU0+oeL109zVHEYE7PtC45zmNEJik/2lMV+41
	 WUzbRXKvVQQqwFbCy627FZWTp6j9hQ61mj/32nw6AOwMla+N+OepBmn87cF9CRa7H4hsA
	 mE8ekjc/LBmuTDDaiqfw+b19TApBNjZ58eW3O5sDadFU1XwE7xKznViMQOv88B5kXTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794571245;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=r48ECBIn/ZDjW20r1K8xJKQyd/oDeFIv6pFjVhzh+D0=;
	b=hgBAW9VeHKaU4YBimJ/nU70p3AM4mw7xk3roL9A1OaFjoiO2HCkhWuMeZLknlrq8xlku
	 pLo0gKQTDVXXOKJS24kbQaA/rdVYkoxHyFH8yntXC0nvOWxunrYcU18LvNvhWAyJFqYlZ
	 xPCy2ETaGVn02L6TgSr2NIgke3KecKxXVgw4SSHvO1ER90g2wXrPqGkgTkacvF96IFMkq
	 SORRq9K4d8IF9AwedWkf9AXp5FXEadwryPJWsow/Ozoj3iB768Cc2m2f9PmqrzVnOLcK2
	 IEQ59DJ0LdpcA/LpHtIBDAMgpS2/WOtA9CXps2/uO1NoDDNvsuZtecfTWTaxg2m2FOw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 76DC21F000C5;
	Fri, 13 Nov 2026 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571244;
	bh=r48ECBIn/ZDjW20r1K8xJKQyd/oDeFIv6pFjVhzh+D0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=JKw2rG7NmSJ0OZsoWeMPwc6CUMSfq48TXhD3DOdQHLNCERgim0QtfB5UwTAzXOE51
	 seLyLd4vVgPf42hcvtfwT0Y2DyGKkhwhCEG/Vc0RoBHVKZm5JRbXUTJa1iaHDVkMF5
	 dMV8H3xdydbc97gurEhi/blu9A6iTUl2oW/6rEt9tS1uBl7gOUmzMCeS6KctMaFqKt
	 noseV6Tlfw37TL1ap2LFgTr9fzem6mvAxkMJey1NsFguu36n76zB/rdlIEbmZ+WmoZ
	 Xio/kzt685Lwb70fKyEsMyHvA85CqEQwxEgZaNGKHj0UGUilMw4UNBvFRC5bwuPoGU
	 lylAkZ9uOZ0ig==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CA7B34776C;
	Fri, 13 Nov 2026 12:00:43 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Fri, 13 Nov 2026 12:00:43 +0000
Subject: [PATCH] smb: client: fail SMB2 responses with a bad signature
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOr79moC/yXM3QpAQBBA4VfRXNsyu+XvVeSCNRhlaQcpeXeLy
 69O5wIhzyRQRhd4Olh4cQEYR2DHxg2kuAsGnegUEY2SudVKeHBK9wZTW6DNMwOhXz31fH6vqv4
 tezuR3d4B3PcDLQXJMW0AAAA=
X-Change-ID: 20261113-smb2-sign-2f316c91c873
To: pc@manguebit.org, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, sprasad@microsoft.com, ematsumiya@suse.de, 
 smfrench@gmail.com, ronniesahlberg@gmail.com, bharathsm@microsoft.com, 
 linux-kernel@vger.kernel.org, daniel.birtwhistle@gehealthcare.com, 
 samba-technical@lists.samba.org, tom@talpey.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794571242; l=3189;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=LRob2AeIi0gkoL5eSGnmBKas0pFGU8uy6TfgbFE1mtQ=;
 b=HU4LLqGOcXfw3OOVZEtRfeFawNQnt3pvzcrPRSZVVEmzXZD7IVGBnvKk7Mf/cF8D6itDlmZxJ
 0j/ps5pnxmcC8GHOzbGfeHx2SNxuIQEKbeQ4VeHeFS1SYyJa14ZuIbT
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

smb2_check_receive() checks the response signature when signing is on,
but a failed check is only logged:

    rc = smb2_verify_signature(&rqst, server);
    if (rc)
            cifs_server_dbg(VFS, "SMB signature verification returned ...",
                            rc);
    ...
    return map_smb2_to_linux_error(mid->resp_buf, log_error);

The status from the response is returned as usual, and the caller goes
on to use a response whose signature is wrong. This is the path for
synchronous requests and for smb2_writev_callback(). On a signed but
unencrypted connection, anyone who can modify the traffic can change
e.g. a directory listing, and the client accepts it.

Return the verification error instead.

Unlike the SMB1 fix in commit dc96f01d54cc ("smb: client: terminate
session upon failed client required signing"), don't reconnect: this
runs in the thread that sent the request, and only cifsd should call
cifs_reconnect(). And fail the request whichever side required signing,
since a response with a bad signature can't be trusted either way.

Found with a static analysis tool and checked by hand.

Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
Closes: https://lore.kernel.org/linux-cifs/SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com/
Fixes: 3c1bf7e48e9e ("CIFS: Enable signing in SMB2")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
We found this on our own and only saw Daniel's report afterwards.

For SMB1 Steve wanted to keep just logging when the server, but not the
client, required signing:
https://lore.kernel.org/all/CAH2r5msfYRdaGAMuTbni-0T20tQi=N=fT4qxiaQ3siQ_WVm=Qg@mail.gmail.com/
This patch doesn't make that exception. If you want it here too, I can
send a v2 that remembers whether the client required signing.

Tested in QEMU with Samba 4.15 (server signing = mandatory, mounted with
vers=3.1.1,sign) and a proxy in between that renames a file in
QUERY_DIRECTORY responses and leaves the signature as is. Before the
patch the renamed file shows up in getdents64(), after it getdents64()
fails with EACCES. Mount, read and write on the same connection still
work, and lockdep stayed quiet.
---
 fs/smb/client/smb2transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 080864b24a0c..62121d7a44a8 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -711,9 +711,11 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		int rc;
 
 		rc = smb2_verify_signature(&rqst, server);
-		if (rc)
+		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
+			return rc;
+		}
 	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);

---
base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
change-id: 20261113-smb2-sign-2f316c91c873

Best regards,
--  
Suyuan Wang <shyckless@gmail.com>


