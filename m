Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792564372;
	b=36lxHuNn/fJ2eDBvr3qkmElZPoDpXRRbOZcB/mXGF4UK+BDRCUgfrVhg/7dX8KMq9XKp
	 0L7aKHgL5KPKDMY+6vfYfXkyGee+nuJ8W8fUdrZ1UDJljJ0IwzifnjIE3jgtJoKLJ+JyK
	 fKOWJfG/avqIqg7Z7cZrSiNFtahXLRqVroUoYf9Ww5ppvdBXmnpEHPE0F0vBEKhqF97UF
	 trxH7KdXxjoJ6lUdJHvmN24tblZRQc/6wihGBJNYWr96LuaQNuE9Di4ZVTRnqXhEN81tb
	 f9FydwBC1FUe1bK+MK4SwrxIhWvIBpZiowh19jruACkqhXS0iE1dsv+ePInITGFUXZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792564372;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=A/NVyzvCFNcDr1LXlDK3Ez8QGnN9AH72+DZCVQ+TLgs=;
	b=UVIOU+L7rACg+Qp+6WKIJ4CCmYT0BHizXLmOIMTlOwwqgv9Di91idJd4G5EVwVRLDygB
	 1ukvf5uWOYRbPlWNv/bVIwr+Yh/2cW3TvWzXmRhOrY1ghs1D2T3lYQY7VeQ5ty6BbxKrW
	 hGjBI5+fZ20wJasiHEnaytWkClnw3kljSy5nF1td5o0vczfwZxqZrdMWzad+9v3hNbygS
	 dvFbp/E01TtGlQMycUxH2u14AN528ETJ1ZUz/38lqC6ZeAehvtXpnwXhgBK4DwyoukCch
	 b4TvoJY+hY9RnRaBJdM4zNVpuCZufFGGXun8lar5L9Q/QIKmc0Bs9pFn2JE3BXQ+w8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y/w01IC0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD41606A319
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 06:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y/w01IC0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABD11F000CF
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 06:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792564371;
	bh=A/NVyzvCFNcDr1LXlDK3Ez8QGnN9AH72+DZCVQ+TLgs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y/w01IC0fAikJny5cP8bOtYsGxgOuC3Rsb65PGntaFqie2ttO4yCry2XbLle3HiCS
	 W4/7OIXo08bNcnpt7qvVEj4UQ6FlY/6BqownVzY97nQNKTOI9u6OVpXsKEeypsdUAa
	 fs7johGO5oSPmY1o/yMVoC3jCoBiGWcRYiL7qYsQ5htADR/eWe1EgBeco7TFOPdblk
	 u0ULU2TK4su9tZLtpD0JGuZwDGkkm/MeCSKPpu79zMxUK2scD1L90EX+eXP+Vd6OnP
	 LovwjVkmk8xnfJL0uKsH05/7HOjZmVNRGAmnNcd+Dh5rceGVVxCRAJpCbyIItRd2VV
	 iU0zUxFNC60NQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c418e215671so35670366b.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 23:32:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByPvkDhae0M6SaH3EnYbW381EuxOm2dJsQ909A/mjcCcMB1N0wrC9LoY/OeBQmE3vav7EwOpwNFtgh5@vger.kernel.org
X-Gm-Message-State: AFq9FYIOe5FMC446fgoyd/LrzgGrvHcOQGsXYWK7MGvgXLeJCcGPzWOq
	PTHhWXZDZJH6T9wJXhXx6mmHTevaTnPXd6E6bIv0XLeKAi7h/a6MI7apXcReXx+KRBABTzEEhXE
	YAhBZQ4p8RfRlf9eXH6e57yj6CmwVUy8=
X-Received: by 2002:a17:907:9719:b0:c40:7381:1b92 with SMTP id
 a640c23a62f3a-c46799a4c65mr91702666b.41.1792564370366; Tue, 20 Oct 2026
 23:32:50 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020194545.3254790-1-hackerowskiy@gmail.com>
In-Reply-To: <20261020194545.3254790-1-hackerowskiy@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 15:32:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-sh6bue0HkVhaffja2EQ2N0tPdQkXWg_Tji=XY9Hqyww@mail.gmail.com>
X-Gm-Features: AclHuK_cOLqucL9cjvuyuPtWIhw6z_j7lb-6IQwjTrHQYVf4q9znoBRDtqGaPpE
Message-ID: <CAKYAXd-sh6bue0HkVhaffja2EQ2N0tPdQkXWg_Tji=XY9Hqyww@mail.gmail.com>
Subject: Re: [PATCH] smb: client: hold server info until cifsd exits
To: Eduard Zateev <hackerowskiy@gmail.com>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com, 
	syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 4:46=E2=80=AFAM Eduard Zateev <hackerowskiy@gmail.c=
om> wrote:
>
> The last session reference can be dropped while the cifsd demultiplex
> thread is still running clean_demultiplex_info(). That thread frees
> TCP_Server_Info there, racing with cifs_put_tcp_session() as it releases
> the server crypto state. syzbot reported a KASAN use-after-free in
> cifs_crypto_secmech_release().
>
> Keep an object reference for the cifsd thread. Defer final crypto,
> session-key, network namespace, string, and structure cleanup until both
> the last session reference and the thread reference are dropped. Drop the
> thread reference after clean_demultiplex_info() has finished using the
> server.
>
> Build-tested with ARCH=3Darm64 and W=3D1 for
> fs/smb/client/connect.o. The KASAN reproducer was not run on the patched
> kernel.
>
> Fixes: a5c3e1c725af ("Revert \"cifs: No need to send SIGKILL to demux_thr=
ead during umount\"")
> Reported-by: syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D5c3ed2a0de3270efc921
> Reported-by: syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=3Dc2ec61adfbcb24e5ec20
> Assisted-by: LLM OpenAI Codex
> Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
Paulo has already fixed it. See:
https://git.manguebit.org/linux.git/commit/?h=3Dcifs-fixes&id=3Dfcf942f9eec=
a644c37e03bcc829d3248c0995348

Thanks.
