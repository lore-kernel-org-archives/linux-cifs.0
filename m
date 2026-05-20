Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983DA39B49D
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 10:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779272765; cv=none; b=dyCmUJ51ItBbeSrWWZ7Z+vZ8v4n35zE9N7KBfTTJakknE+JfS6D3zbzRA1FFJVbP4uHLJlw0MirSJWeCaJUlRZzpmvXTAc5Lrmugf7q6GamCyU2YNr6nXSBPRluW2UifdKvR9CyAbMWcmeto+6G8iYXijWbJ1DlwzmJ6oDA55qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779272765; c=relaxed/simple;
	bh=2BwHg5w0YwehBzbBbHaB6OCJL0LJyFr8rkoDfLkIU0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJILHL0Fo/GFlGEUeNy9WAmR3rrpiI7OZGRbE+FlyMh0fPvirp8/hSv26mqtO8axKlkM78cXEB3/Xk7Px3s1KvdTDT5oq5osxPmTBem9+DEdsxKvHQCYLJFH4hrtIUv3LbrDdE7EpmCGLCBbml2xLcBHWB9NkhV8+JAGHlYcSWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=054yZkJ2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="054yZkJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=q+75UoPmS6pHg2Snl9VBWgzyJpryJfH5HxHBy2oe2n8=; b=054yZkJ2ERGwDWKNSvDQZ31jVk
	pVpeIakTAVOsaoBZ0mvbIQRClh1hIRbRS+JkTKLPVxwMCJKtJoTmRV4R6d5GhciDB8xkCYqIVlI56
	fbGDGDoYiiB3Mn2ryqX5S9RGFAdJM/V8h7Ial0epw0nrrlYkysqIE8QH+RD7hpVGyqWv5oAq1HLdu
	rd9hioAZJPE/vbzymrSqc9YEjmHAhr/vIDwjxflJkRRE7dUMrBGhViUEXioran+RFhvm8Sc5rsyEj
	7Ir3xw8+HjogqvqI5hM+XuLZc/GOUMHgu6nTkI692u2Ael1DjV7he3pNFEWUrYZqH7RageImjWPFU
	U48/tdzvjDSDfL0HOs9MVaF3ptOddf5JGMEC43xtpEBvqO8f33Q//iKJh1AnHMJ0/fvaEeZpal+f1
	EDySQADsdjUwmLEtBqtRqBn09jMHmd1eaP5wfuou9sVFf/Pyuxk5UOhSTtTGtPVEz+50TJIAETEDt
	w2+gRNq8VYOQisChFBplnn97;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPe7g-0000000AN9f-3SVv;
	Wed, 20 May 2026 10:25:56 +0000
Message-ID: <0cedd361-1774-442e-8196-a9fcd881531b@samba.org>
Date: Wed, 20 May 2026 12:25:56 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: chenxiaosong@chenxiaosong.com, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi ChenXiaoSong,

I just realized that the initial mail of this thread actually has the patch...
And I fetched it from lore.kernel.org...

A few comments below...

Am 19.05.26 um 11:51 schrieb chenxiaosong@chenxiaosong.com:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> When client stops querying a directory for change notifications, it should
> send a cancel request to the server.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   source3/client/client.c | 57 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/source3/client/client.c b/source3/client/client.c
> index 1d3656aab34..7fa850a6dd9 100644
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
> @@ -4653,12 +4654,40 @@ static int cmd_newer(TALLOC_CTX *mem_ctx)
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
> +	if (state->notify_req) {
> +		state->cancelled = tevent_req_cancel(state->notify_req);
> +	}
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
> @@ -4684,14 +4713,36 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
>   		goto fail;
>   	}
>   
> +	ev = samba_tevent_context_init(frame);
> +	if (!ev)
> +		goto fail;
> +
> +	se = tevent_add_signal(ev, frame, SIGINT, 0, notify_sig_int_handler, &sig_state);
> +	if (!se)
> +		goto fail;
> +
>   	while (1) {
>   		uint32_t i;
>   		uint32_t num_changes = 0;
>   		struct notify_change *changes = NULL;
>   
> -		status = cli_notify(cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL,
> -				    true,
> -				    talloc_tos(), &num_changes, &changes);
> +		req = cli_notify_send(frame, ev, cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL, true);
> +		if (!req) {
> +			goto fail;
> +		}
> +		sig_state.notify_req = req;
> +
> +		if (!tevent_req_poll_ntstatus(req, ev, &status)) {
> +			goto fail;
> +		}
> +
> +		status = cli_notify_recv(req, talloc_tos(), &num_changes, &changes);
> +
> +		if (sig_state.cancelled) {

I think here we should check for NT_STATUS_CANCELLED.

And sig_state.cancelled should be checked before the next cli_notify_send

Thanks!
metze
