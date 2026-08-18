Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAC472621
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787012310; cv=none; b=jNCH10vSxlLT9YPuXttIRhacY4fTz2ZSgGChxK/jWfDR15+L/mkhA47eUdmwzSmVCUhwskdvvzNlsmxE3QLerOLdqZ//UJbiKhCU0noXY8lDHmgTK8R5OJZReK5YMdfZHbMYgerALft0tMHKN8YGb5DS4iQSoiZCasksuhtG1EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787012310; c=relaxed/simple;
	bh=lEqRLJsz2zFi3RY0L8Meap62WRf9/tkCSFWyR+KOScU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuOpgdis5n/2b0oOChbZ2fBmBwyKaMukixpG0do58cjzemgsRbEVqel7QZBztiMxYz92zbYgXr0lm1CbZ6GDq3mF+H+qhmjf/LeL2q2nHA3lZL6aioMybLFkuDjwZ0NfKltA3jCnsjWOEo0utWOods7hSFlirfeEU9OHrSgghM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJBI+nKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJBI+nKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABFA1F01558
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787012308;
	bh=kBMrD5uPLprd85mL+To2H9xZCWjMIYqtknyksJER9Cs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FJBI+nKBB5ofn5bk6a3gPf8PAN3NfX28jPGVWURsN/JT7daHK9wVbCwtP2nqIEQuu
	 cHR0wkV0LfteOs/cFpA8Ytvil9se7GbBErasiV3MZaNMkUqoz5ik8OtA61ZOt+3cvf
	 aaa8VpkWWXfQnGzatLohZYlEnNFVGLBAc5GX9zL73LHV10Man4l6lMWWEPuzBiRayD
	 YFUC6V6e6gPe+DFgBVFvkWpgNcyaO264n699E64fnFL4Y3tctbp+8HKAlVIY+4bkjK
	 qLZ7RBqauKsdYXnIksc/hsGTdYiWbxrQ8jAfdPV5yzxATpartsTuAaVpv/Nl2jlzM0
	 Li0cbcgFlI8VQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1712a04ddaso673045166b.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:18:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RocgxIKE2Rgg4Ug/8INsPBiNwhQtwIQcQ4UChO9J0meXDgCdhd8WTOrOW5H0ddHEPN41oxgAppOMMjw@vger.kernel.org
X-Gm-Message-State: AOJu0YySNUemvghCZS0JZjtavD0cJCktfyAsNyYBKJH4eJqmEjhDWUko
	DjO1X1dEW1397Q/CiQNDM5yoylUHvsbHZM9btTLmCISyroHkd2UL8VI8mhnlZ6l+fCI+Uyn6IGZ
	0mR+zulAH0JZpp7QWx5gNmTCSSZsLABI=
X-Received: by 2002:a17:907:1609:b0:c16:b87:de64 with SMTP id
 a640c23a62f3a-c212a1250a6mr1429158266b.15.1787012307087; Mon, 17 Aug 2026
 17:18:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729192002.876156-1-clusk@northecho.dev>
In-Reply-To: <20260729192002.876156-1-clusk@northecho.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 09:18:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_hupeuYgwc+ndHtytwxqDcXhpuAOiHkqkXv44fFTojhg@mail.gmail.com>
X-Gm-Features: AcwNN1U42Xw4fRJbjBWWj4U4FXnCyes2RE8Sit0JUqF5a1U01YuAgZjbaHSxZ5U
Message-ID: <CAKYAXd_hupeuYgwc+ndHtytwxqDcXhpuAOiHkqkXv44fFTojhg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: set replay flag on the read send-error retry path
To: clusk@northecho.dev
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 4:24=E2=80=AFAM Christopher Lusk <clusk@northecho.d=
ev> wrote:
>
> smb2_async_readv() and smb2_async_writev() end with the same
> send-error block: if the error is replayable and smb2_should_replay()
> agrees, tell netfs to retry the subrequest. The write path also sets
> wdata->replay. The read path does not set rdata->replay.
>
> smb2_should_replay() is not a pure predicate. It consumes the retry
> budget and computes the exponential back-off, doubling cur_sleep up to
> CIFS_MAX_SLEEP. That back-off is only applied where the replay flag is
> tested at the top of the reissued request:
>
>         if (rdata->replay) {
>                 /* Back-off before retry */
>                 if (rdata->cur_sleep)
>                         msleep(rdata->cur_sleep);
>                 smb2_set_replay(server, &rqst);
>         }
>
> So on the read path the back-off is recomputed on every send-error
> retry and then discarded, and SMB2_FLAGS_REPLAY_OPERATION is not set
> on the reissued request.
>
> netfs does not pace the retry either. netfs_reissue_read() calls
> ->issue_read() directly, and fs/netfs/read_retry.c contains no delay
> of its own, so read send-error retries reissue immediately while the
> equivalent write retries back off.
>
> The read response callback already sets rdata->replay under the same
> conditions, so the read path does use the replay mechanism. Only this
> send-error path omits it.
>
> Where the back-off belongs was settled while the commit below was
> under review. David Howells asked whether netfslib should be doing the
> back-off [1], and objected to sleeping inside the response callback
> because that runs in the cifsd thread and would stall the socket [2].
> The sleep was therefore taken out of smb2_should_replay() and moved to
> just before the replay in smb2_async_readv() and smb2_async_writev()
> [3]. Setting the flag here preserves that arrangement: the sleep still
> happens at the top of the reissued request, not in a callback.
>
> Set rdata->replay here, matching smb2_async_writev().
>
> Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consisten=
t with other paths")
> Link: https://lore.kernel.org/all/1652858.1769038134@warthog.procyon.org.=
uk/ [1]
> Link: https://lore.kernel.org/all/1653031.1769038583@warthog.procyon.org.=
uk/ [2]
> Link: https://lore.kernel.org/all/CANT5p=3DpXP3+CywpmK-on2uTvxO3S=3D31_B8=
5_UDR7RoK1dQVtMA@mail.gmail.com/ [3]
> Assisted-by: Codex:gpt-5.5
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Christopher Lusk <clusk@northecho.dev>
I will apply it to #for-next.
Thanks!
