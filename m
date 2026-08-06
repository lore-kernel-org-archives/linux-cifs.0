Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955222F9D98
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010714; cv=none; b=OQtnSuk6yhTAECSuQW7ez7WmOXAcyD+nzSLwEcs7XJ9Op+dGi25VARqTgI5WWz4w/eLkF9UH6oM9jkVmgbSfNYFmNFuB4AAR32jZTQCPilo/V1jzjkOZJVFTIEXnb9erQezMcRT0YzNeezopEFNkIZ9ToboB8LIarInaEr7tjLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010714; c=relaxed/simple;
	bh=dRxJQHnmConeDEJ3LoXEh8oDZSVVwphZLwK8Nq2k26c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=l2GxupL4o8mnZxo6wxNUjSH+0xfoEk5lUbIWyY6znM64JCirk2yKZz7wpqtAtDqzkKwlrGXLQghLaFWi7tIANDU3ob/c8Jr/ddjj9st2bs4DsU/j4GsMsL/eL6qUmh6sVOVgU7owVHXIqT+fYT36Ckf+0HSue98MXCABUYU/ui8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=pvNCaUgC; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="pvNCaUgC"
Message-ID: <ab96c862-dee9-4ef5-89ad-64ca03b784bf@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786010707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjLWhrdcCKvVSLR4j0dw2iSGdZV8oF/xHEwAAtHrdUk=;
	b=pvNCaUgC7AHqhrdaM+lGb+J6GrbPqdrD7LLVg7cMSKkcXym6txzqQEflKsfqSXlUsXUMV9
	wQvuUJZIly0zzWISJkmIxYZJVJAIv429RL8C8JCnk6wpOJVY7LqIGtvY2B7Mi1LlOdGKak
	OFzTnEmIAB2lCAdXhrNxn9wNDqAZgn3GW+ykNTNVPElDC2HsdwnSMcvoYZIZizMNyIWP69
	tRC8NTOlSQ6m+tesgbwDpu/EX6oc0/jjC4vUnCigPfB5E96XGoDa5weAoFXLl3aTISeUN3
	53W4/GFvtNxMhQvo1ilWy/tnfOsO64ZGLrXCkXDdL8XRM98PwwgyylhCPDmEKA==
Date: Thu, 6 Aug 2026 18:04:46 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH samba v3 1/1] smbclient: cancel pending notify on SIGINT
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org,
 Stefan Metzmacher <metze@samba.org>
References: <20260608142815.388768-1-chenxiaosong@chenxiaosong.com>
 <20260608142815.388768-2-chenxiaosong@chenxiaosong.com>
 <8cc6012c-b0c6-4e88-b70e-27381ab11c1a@chenxiaosong.com>
In-Reply-To: <8cc6012c-b0c6-4e88-b70e-27381ab11c1a@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/8/6 16:04, Ralph Böhme (@slowfranklin) 写道:
> 
> Ralph Böhme commented: https://gitlab.com/samba-team/samba/-/merge_requests/4530#note_3651484334
> 
> 
> Thanks! Generally looks good. Nitpick from README.Coding, in Samba we always enclose code after a conditional within braces, so you have to enclose the single line code after eg if conditions in braces please. Thanks! This is to ensure a future developer who adds additional code to the code at that place and forgets to then add the braces, doesn't break the logic.


Thanks for your review. I have updated the MR.

I made the following changes:

```
diff --git a/source3/client/client.c b/source3/client/client.c
index be41360dbdc..e12524ddf2e 100644
--- a/source3/client/client.c
+++ b/source3/client/client.c
@@ -4669,8 +4669,9 @@ notify_sig_int_handler(
  {
         struct notify_state *state = (struct notify_state *)private_data;

-       if (state->notify_req)
+       if (state->notify_req) {
                 state->cancelled = tevent_req_cancel(state->notify_req);
+       }
  }

  static int cmd_notify(TALLOC_CTX *mem_ctx)
@@ -4692,6 +4693,7 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
                 goto fail;
         }
         if (!next_token_talloc(talloc_tos(), &cmd_ptr, &buf, NULL)) {
+               d_printf("notify <dir name>\n");
                 goto fail;
         }
         name = talloc_asprintf_append(name, "%s", buf);
@@ -4712,12 +4714,14 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
         }

         ev = samba_tevent_context_init(frame);
-       if (!ev)
+       if (!ev) {
                 goto close;
+       }

         se = tevent_add_signal(ev, frame, SIGINT, 0, 
notify_sig_int_handler, &sig_state);
-       if (!se)
+       if (!se) {
                 goto close;
+       }

         while (1) {
                 uint32_t i;
@@ -4730,14 +4734,22 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
                 }

                 req = cli_notify_send(frame, ev, cli, fnum, 1000, 
FILE_NOTIFY_CHANGE_ALL, true);
-               if (!req)
+               if (!req) {
                         goto close;
+               }
                 sig_state.notify_req = req;

-               if (!tevent_req_poll_ntstatus(req, ev, &status))
+               if (!tevent_req_poll_ntstatus(req, ev, &status)) {
                         goto close;
+               }

                 status = cli_notify_recv(req, talloc_tos(), 
&num_changes, &changes);
+               sig_state.notify_req = NULL;
+               TALLOC_FREE(req);
+               if (sig_state.cancelled) {
+                       printf("notify cancelled\n");
+                       goto close;
+               }
                 if (NT_STATUS_EQUAL(status, NT_STATUS_NOTIFY_ENUM_DIR)) {
                         printf("NOTIFY_ENUM_DIR\n");
                         status = NT_STATUS_OK;
```

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

