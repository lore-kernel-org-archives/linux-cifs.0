Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792453700;
	b=aFDPc8rmhdxX/ep97qF8fuAqNlqE7W7RtFho5oyrJgojYO9uLsiSyfvFCxsu33xkCIDK
	 rMEvX9bV4Cy3AaK5naUKiUpO1X03uqpCqLt5WRjkn5Kiy4EkxEtQFN0ecubRReAUOcrp6
	 Z40yqIjlXCi30kpM5MsgUtD5qPHiMyhQwmCzPjIP6pDJtIwnGIZkuLv/iN5Qt4U4093Qv
	 3NLnAjBxysc+YkCW4sPe/+vs0wf+5r5H95cRBPKVVYdkaC11MNPP6WWZZvCaO0+n/Wrjq
	 sp42Tbn1Vk0IdQJaB/i7Gu+wbX8Af2qwCuQn2R3tXlMd2A902thxdzr6hwTF+HPG5Yg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453700;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=uPR686aha/s9p5KrnYFj4bxjpjg5RBo2/QPkK83r2BY=;
	b=rb58G3t2eVvdcQLcPWUDLQTGdawEXKDKOTbiBhwUeg9eSOlaX0hrsDD2qBuzF7o6SiCb
	 6TymOjGCgl9sExyhXMsc8mgoU+D/y5NZFB2Z+6LF/US9Is4LDNti3kI24tk2y3SsKTcxK
	 KArbmoj2QwHkNksublppntXeaUtjVc3b9ifsAqgvRnHxZlDlHSPi4rYAAnPGeT99hukx3
	 DLEmSl2osc4aM5IU03KqUFNJwdQmBqPYHQw79VYiiFaLGrJoFIPyokOCbMJVrOjamb3tL
	 1qFAYPY7cy+zDJsKhcZpbTip7v+hIJV+pcOmkI9WYMq5Hy+MXnL1HBzPHjrISd3Me9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sZ6xiB9D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.182
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F52606A31B
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 23:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62F52606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sZ6xiB9D
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ab38a051aaso22489127b3.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 16:48:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792453699; cv=none;
        d=google.com; s=arc-20260327;
        b=jDyCl51dfyKm8HdVQMTg7PG79ABXUGQ/0VX7kQHa4izHkq+oUhOHmQyjCe3zw7sf0H
         0pEGhneI5g+7DLlGFYuvyC9uBGnuqrNuDdOto80gv81d2wS/cSYABWCa11HAwIhoECgM
         Vsw+QqKQ8tFZpBsZUhRmGkcKR3ZY1WEi+rj638mlSombxr/Xjr29WiYRZ4RosNccnIjL
         2l0sFwYvVJlf6pl9q7En8tCuG0PnPsJUODxyASlzhu1IhccmZXytSOccXEc84qvuvDHx
         9UWs9EK5FjHNhVFRwSpKM42JBHDUcG6PRWyVhcIsG0W4gxJRI7TTYlQywmX7t6XBS9jR
         jDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uPR686aha/s9p5KrnYFj4bxjpjg5RBo2/QPkK83r2BY=;
        fh=kH0xamkYoUp8lVCxIi9w5C9/waAa7UrXU3oXFU5PLC8=;
        b=XF7+b+Mn6aB6GToo4rE31wWPakY/fudKlKa1znsX95Vah/i9L/ZB588Dm0O9V0KGPH
         38XiIEcB3J1x1J9GjoPwRlC4KijauCyEKpD7N6o20BQ9yDc7k8FNPunfX2ssLMvWNRhl
         MzH1rfvbtN+VqdL+LxnnkKorABH8c39sq+l5aVVT10p+fYgSQHtF8+RddCYuDZYe1lpn
         U8JY2Kikf+qHSNrCC3p+J/SQwp9bhv4fdEtk2+X1khO56x46ki0NO1sjQHjt7ZFuoVTu
         FZ+1kPMeOCCwmGlFSBg1fjRc3rKjx07UDOUMVUoR6SLCIdhtoIQBibYgmSOm3hnBRFxj
         17OA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792453699; x=1793058499; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uPR686aha/s9p5KrnYFj4bxjpjg5RBo2/QPkK83r2BY=;
        b=sZ6xiB9DuvcbqVv0gIB/zNnczwsp8q30SPuOjUTT9uajYr9Trkdwl5LZ7iAPMFRhB4
         vWQgSrvjExCHojmr6NPW41q2+N2t8vsnXC0CRNnxlJdLJx9cBjeDhJsV6G0StaWjrWdw
         +I4Vl1SB+UsQ7UecidixlCOBL7xn5/67LmNFrA5NDnb2izdlycFvHNtglThC9KWhsFpr
         2j/DG83kTglmE46OhDnqBLIDtDmozPA04Me2koYZ3GCfcA3BJbsOUGeR3BfUfyEmmtIB
         SS1RxU2tcnDMpR5dv+1Bs2RICDJCe0JkEfNu4/mEW6TOe2qHbh9Hp7IP3/WkOQm2oQLu
         xDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792453699; x=1793058499;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uPR686aha/s9p5KrnYFj4bxjpjg5RBo2/QPkK83r2BY=;
        b=NU9JHZ2gL/cyMiYpaxrdq6Bv3KczzzPDEcFkBS21cw9hyqNro4nWLcIdcmAbrTbRw1
         hFRI4NlWsbL/h+GPN6a4M2KirL7dOzMvmZpqTWWw8s6XpPrTkE6w8x8X6tMPgrtUhtUR
         q36FFM3kcEnEQGYPI1lHkqHZGCpPJXGhRwbbVPy+OUnQVtG7xUPqXhb0/RsmtAXqH3V+
         KUF1kCp5LR2gZ/Hh/5vi2jeTEx+NH/w56mzJAcozCcg/5ikgnNFBugu/11cJXzIy4uMR
         CVbkjVcMYEQ+GwnSh42tXPM2ESKy2gJWOgt31QUdD0/4WdLGgnaqYw8BnfdDFquAx+rT
         iLIg==
X-Gm-Message-State: AFq9FYLEFJD79aYF/wC+vJbp9kuG6+6igp9eL0XnyujVBIug4IFHSFlA
	PvMEwrEbelGFtKuwg4XoBJdeDtNqrgHOlwfdcnq0DzP5+ftwC8pL4s4UZ4r/KPJD7KkOwjX4ie/
	7rQw5YtfobqNtkfykaiid3fEQ8xqTPOA6Fqme
X-Gm-Gg: AYBFou2Mwpic8wfJG2cGzOEOvZxIuloVmfh+PJEJdml2Qt+aSZtvcCU0LTJYo0efOMR
	WkJZRq/Lq+sOOKsa2DWyoXINbmj0iFuAhBbQVXibJKVhS43/59Tk0sabt4TAbivLGieq3BxOHCJ
	UlgCLIV69yrGICItfT51e7hXH3AJsv2miXnaoygHhkKDsijUSyoEEJWRgCjtRZHXcBU9sDp+LjA
	XiM2fzwvn5LIKgZzpB0aAkK8MmW2FTugYnJqGOOAmqpzXNp6wpLpu9MrGTmcgGP5tGdDIgBOmBo
	f5uIq3TJX+J3z+nFiBfsQn/SWeeDfq784Y2cUgaP7PxlzoBKFOE0jo/i9TvvpexwJvQ+BtD15RK
	uIXBIfnKwWjwjxg==
X-Received: by 2002:a05:690c:447:b0:878:cee5:9885 with SMTP id
 00721157ae682-8b0f220138bmr32688737b3.43.1792453699302; Mon, 19 Oct 2026
 16:48:19 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Mohammed <mohammed.saad.alquraini@gmail.com>
Date: Tue, 20 Oct 2026 02:48:07 +0300
X-Gm-Features: AclHuK-gvoCc23Waig2bSdFxXWyGK8fjHfJcG9ab-NPqqE3Ye07teLWp7_WHx80
Message-ID: <CAD37_9gGnApAuagqOuZ13WB=DW8c_ZpWFBX4cE00YtGhmE2PbQ@mail.gmail.com>
Subject: [Bug report] ksmbd: fd_limit leaks a slot per durable-handle
 reconnect -> cross-user open DoS
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Namjae,

ksmbd's global open-file counter (fd_limit) leaks one slot per durable-handle
reconnect, so an authenticated user can exhaust the server-wide budget and deny
other users' opens. Validated end-to-end on an unmodified kernel; every number
below is measured. Found with an LLM-assisted code-analysis pipeline (disclosed
up front per security-bugs.rst). Low severity -- it needs a non-default config
and the cap is already soft (see caveat), so this is a regular bug for the
public list, not a security@ case.

Affected
========
fs/smb/server/vfs_cache.c at torvalds master 70dd4ee7 (2026-10-16); the reopen
path is unchanged in current ksmbd-for-next. Requires "durable handles = yes"
(the shipped ksmbd.conf.example has it off). Not a regression.

Mechanism
=========
fd_limit is one server-global counter. A slot is taken per volatile id in
__open_id(), and released in exactly two places: final close (__ksmbd_close_fd)
and the idr-failure path. On disconnect the session is destroyed and a durable
fp is preserved with its volatile id unpublished but NO fd_limit_close(). On
reconnect, ksmbd_reopen_durable_fd() calls __open_id(VOLATILE) again for the
same still-open fp -- a second slot -- and final close returns only one. Net:
one slot leaked per reconnect cycle, in a server-wide counter, never returned.

Impact (measured)
=================
With the shipped default max open files = 10000, 20 authenticated connections --
each holding exactly one open file -- exhausted the global budget in 56.6 s
(~177 leaks/s); a different user's CREATE then returned
STATUS_INSUFFICIENT_RESOURCES (0xc000009a). The leaked slots survive the
attacker's disconnect; only a restart frees them. The same open/drop/reconnect
loop is what a benign macOS/Time Machine client does, so a server also degrades
under normal use.

Caveat, stated plainly: the counter is global with no per-user quota, so one
user can already exhaust it by holding ~10000 opens; this bug's increment is
that the leaked slots are unrecoverable and need only a single handle.

Reproducing
===========
Self-contained SMB2 client (C, no third-party deps) against a mainline kernel
with CONFIG_SMB_SERVER and ksmbd-tools; [global] durable handles = yes,
max open files = 10000. Authenticate; CREATE a file with a batch oplock
(RequestedOplockLevel=0x09) and a durable-v1 request context ("DHnQ"); read the
persistent id from the response. Loop: abrupt TCP close (session teardown
preserves the handle), then reconnect on a new connection with a "DHnC" context
carrying that id. Each cycle leaks one slot; once the budget is gone a different
user's CREATE fails with 0xc000009a. Setting max open files = 16 makes it
visible in ~15 cycles; an instrumented run shows fd_limit going 16->0 with 18
takes and 0 releases. Full client source and logs on request.

Fix (Not tested yet)
===================================================================
Return the slot the preserved fp already holds at reopen, so it keeps exactly
one slot for its one logical open:

    /* ksmbd_reopen_durable_fd(), fs/smb/server/vfs_cache.c, before
__open_id() */
    fd_limit_close();   /* preserved fp's slot; reopen must not double-count */
    __open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);

(or move the accounting to fp lifetime instead of per-volatile-id). Must keep
-EMFILE -> STATUS_INSUFFICIENT_RESOURCES for genuinely new opens.

Tested by hand on arm64 (70dd4ee7); the mechanism is architecture-independent.

Thanks,
Mohammed Alquraini
