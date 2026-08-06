Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0924175A5
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 06:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996352; cv=none; b=j6rZPmy2WqKRpwqvPwN63NyUJNDTa2Zlij51LSj6M15IdnweVWW+0SX06ujFN1PQk2ht+b9qF1rBauNmSTBJiY2tM7nkkPfqQocN8tmq675mJ2dSSvNZeN4Kvhtqa1tn1uhovhirueeQ+2z/ByeQXWTDCSjLfYYjn9Mt7bO6+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996352; c=relaxed/simple;
	bh=gCEKoF0iO8MbohgplGbYyYb4lWXZfnNqfqsC55lO/J8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JQNOQ+SAw0IOW8GfMh1Erb4LfEkkbr6x+g3B3LbmivQyPbFMpEq3NosJmXo0uoA6gD2J74qh4StlK4B+6dkm8Oljdl9ORl1bjpwxnA86eI6dFSQgPqj79GxiOlkE6HC0JZI0V1XCeAD3TPAFQDhuotFVUHlgeK33U4trMzcRID0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=uLHFQvNu; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="uLHFQvNu"
Message-ID: <8cc6012c-b0c6-4e88-b70e-27381ab11c1a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785996345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0rfNBWnFRtLXDtJnTmB92kyWKG7vF/Ywfu8db5y5SE=;
	b=uLHFQvNuf2xXHL4r1H67X8uryl3TMTcPT1GfU3JPuix5S1KbKmHTc5NMTOE+uQnO8x9P9Z
	pll7VZCAkll9RzFkxkR5e2M7aFEg4m6RnZjCvQbXJaLzuXYI9Q6rQ+mn0xMm9TLviGm1Ps
	wZPen/3xJLeXqOx5HdDkLi3vQHaws1I7qXh8kMcLJvYDkyURo8bepllZQ3qfJAlL6mDuf8
	+XWAtcAtzJNL/l6YsZDEFNxJnzawb1jDgH1rAgxvEp983jF74pOEzZ3IzHKpxwjO2C1qKR
	evO/T9Rr75YbE8r/Hs2iyzzSUebo1p1VloqErRosqlwtnYcpEWZ9WmRcMKIibw==
Date: Thu, 6 Aug 2026 14:05:12 +0800
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
Content-Language: en-US
In-Reply-To: <20260608142815.388768-2-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Ralph,

Do you have any suggestions for this patch?

I also created a merge request on GitLab: 
https://gitlab.com/samba-team/samba/-/merge_requests/4530

On 6/8/26 22:28, chenxiaosong@chenxiaosong.com wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> When client stops querying a directory for change notifications,
> it should send a cancel request to the server.
> 
> After cancel notify succeeds, `status` returned by both
> `tevent_req_poll_ntstatus()` and `cli_notify_recv()` is
> `NT_STATUS_OK` rather than `NT_STATUS_CANCELLED`, so we
> can only check `sig_state.cancelled`.
> 
> Suggested-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   source3/client/client.c | 64 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 57 insertions(+), 7 deletions(-)
> 
> diff --git a/source3/client/client.c b/source3/client/client.c
> index 1d3656aab34..37693b8f401 100644
> --- a/source3/client/client.c
> +++ b/source3/client/client.c
> @@ -45,6 +45,7 @@
>   #include "lib/cmdline/cmdline.h"
>   #include "libcli/smb/reparse.h"
>   #include "lib/param/param.h"
> +#include "lib/util/tevent_ntstatus.h"
>   
>   #ifndef REGISTER
>   #define REGISTER 0
> @@ -4653,19 +4654,46 @@ static int cmd_newer(TALLOC_CTX *mem_ctx)
>    Watch directory changes
>   ****************************************************************************/
>   
> +struct notify_state {
> +	struct tevent_req *notify_req;
> +	bool cancelled;
> +};
> +
> +static void
> +notify_sig_int_handler(
> +	struct tevent_context *ev,
> +	struct tevent_signal *se,
> +	int signum,
> +	int count,
> +	void *siginfo,
> +	void *private_data)
> +{
> +	struct notify_state *state = (struct notify_state *)private_data;
> +
> +	if (state->notify_req)
> +		state->cancelled = tevent_req_cancel(state->notify_req);
> +}
> +
>   static int cmd_notify(TALLOC_CTX *mem_ctx)
>   {
>   	TALLOC_CTX *frame = talloc_stackframe();
>   	char *name, *buf;
>   	NTSTATUS status;
>   	uint16_t fnum;
> +	struct tevent_req *req;
> +	struct tevent_context *ev;
> +	struct tevent_signal *se;
> +	struct notify_state sig_state = {
> +		.notify_req = NULL,
> +		.cancelled = false,
> +	};
>   
>   	name = talloc_strdup(talloc_tos(), client_get_cur_dir());
>   	if (name == NULL) {
>   		goto fail;
>   	}
>   	if (!next_token_talloc(talloc_tos(), &cmd_ptr, &buf, NULL)) {
> -		goto usage;
> +		goto fail;
>   	}
>   	name = talloc_asprintf_append(name, "%s", buf);
>   	if (name == NULL) {
> @@ -4684,14 +4712,33 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
>   		goto fail;
>   	}
>   
> +	ev = samba_tevent_context_init(frame);
> +	if (!ev)
> +		goto close;
> +
> +	se = tevent_add_signal(ev, frame, SIGINT, 0, notify_sig_int_handler, &sig_state);
> +	if (!se)
> +		goto close;
> +
>   	while (1) {
>   		uint32_t i;
>   		uint32_t num_changes = 0;
>   		struct notify_change *changes = NULL;
>   
> -		status = cli_notify(cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL,
> -				    true,
> -				    talloc_tos(), &num_changes, &changes);
> +		if (sig_state.cancelled) {
> +			printf("notify cancelled\n");
> +			goto close;
> +		}
> +
> +		req = cli_notify_send(frame, ev, cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL, true);
> +		if (!req)
> +			goto close;
> +		sig_state.notify_req = req;
> +
> +		if (!tevent_req_poll_ntstatus(req, ev, &status))
> +			goto close;
> +
> +		status = cli_notify_recv(req, talloc_tos(), &num_changes, &changes);
>   		if (NT_STATUS_EQUAL(status, NT_STATUS_NOTIFY_ENUM_DIR)) {
>   			printf("NOTIFY_ENUM_DIR\n");
>   			status = NT_STATUS_OK;
> @@ -4699,7 +4746,7 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
>   		if (!NT_STATUS_IS_OK(status)) {
>   			d_printf("notify returned %s\n",
>   				 nt_errstr(status));
> -			goto fail;
> +			goto close;
>   		}
>   		for (i=0; i<num_changes; i++) {
>   			printf("%4.4x %s\n", changes[i].action,
> @@ -4707,8 +4754,11 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
>   		}
>   		TALLOC_FREE(changes);
>   	}
> -usage:
> -	d_printf("notify <dir name>\n");
> +close:
> +	status = cli_close(cli, fnum);
> +	if (!NT_STATUS_IS_OK(status)) {
> +		d_printf("close returned %s\n", nt_errstr(status));
> +	}
>   fail:
>   	TALLOC_FREE(frame);
>   	return 1;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

