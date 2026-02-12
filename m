Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449651D5147
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 21:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930481; cv=pass; b=Bflv+4EsUuffTLVzNtiD4wVFbPUFr5UnrvxGdxhDKYmG0mrrnke/fOWPdT68mTxbikISzUHux9DohLXSK/v8n5LnN1jZr5+/5oV8AXHtkdKE9N+a6g7ts+KmPmXkiCIUkINq4bHiT7LtdmMIgcRtm70Mtr6Q4LlfgadtoEJXcNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930481; c=relaxed/simple;
	bh=SOKCWCRr5YpFu/NFeMmLz1mRvSwOeviiUocMLbpIQso=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hpyIkstFbM6i5ZszviML4BMPA65oDAOcEkAVUuZrU2LUzAyC0XkU3gwmiN/0Imb2aoIco/VDOdMEmMFG64SYx/Cx/HyLgi9Eb8JvIFONojwYzNF/3lVh8UVt/95NjsuL7oDkuxsHvUeIXiKTJ+NltNEPu2KqWBxGvpgHLin/4Ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aSkrynDC; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSkrynDC"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c6f21c2d81so34576985a.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 13:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770930479; cv=none;
        d=google.com; s=arc-20240605;
        b=Jd7x1GK2B5NpiVysBB4wmF2VAnIQHUP7lU+BRFwYjmbcQaGNmXvxPXhaBMcf53ad3J
         JISIsMSSWx9zCDAq6RYDzkzNAZNYm5x7fQZnnSzifFV+B8PSJn2fmX7Tmm9dOyWlMUTi
         gH+SwzZgv/TMEhJlVRmVfgLy29C6qdY9UnrVo/WO0GSrETJKVf1janp61Wz0IEogqo/p
         2jxraXjxr4bGfEX9W/PxnH96DSSX1MLNSY72uD9VhkPuuwd7symvy1tuw7VwZAqw3Oi5
         F4wrB9EKeDHc4VKffrz1uhzqFto3uojGi24tAAkL+raV+RYFxuGXn60RQDMmhkVaygmf
         AXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOKCWCRr5YpFu/NFeMmLz1mRvSwOeviiUocMLbpIQso=;
        fh=peQ+izGdoThSoAEN7Ed3MdxybtgVbOQs4KPyHnf35Qs=;
        b=UPF6TXxD5AMLBLcpppIfUE7Xlw65+qqio0jMfO0LTph3a9Sivz3EvneuXam7LVA+XF
         QGCa1g5eKiUxEmWkq9GpvKBkKjSOKoQuz77OhfqcIpYzSfH7CS0FPdFx4J1qqfcD26bq
         DlhUeg21AlbBzbJ6s5qRjyGbQVCdfDCuQhonK7VaQS4s7es1z3p6hSUDch2/bTer0kKw
         F76WS4jm4h4jXZjHLnOIb/gKuW2twurwLrOB5+OvF6WOO0gykNTFLC6s98vglf0kHLNg
         l2Uprl2ToQZI0hbjwiOFzFGGof1YnOuRNsOzXNyDivX5Ts8s1HFbbzvfCR7yD1uWJhOT
         HtEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770930479; x=1771535279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOKCWCRr5YpFu/NFeMmLz1mRvSwOeviiUocMLbpIQso=;
        b=aSkrynDCvZC026EHYISxkC3t9M4meg2wFSOJPIP+hQluUVrwndFnLSbzsHdIoPsHqV
         xJzkI1NywtqC8zDPgVIRAjPsyuK6zxkG4I8lpaZ02SS5wMFm3MsvxRJiyYPJLl2Zn42p
         9kY5g0DdmKybXqTTRybChyMeoQhGEbu+xib7djmNoOwO4rjMpWy3ZT5EXqKEUhC+ArjX
         pNAMdbJ7K307GETJRMOVbvfhzB+y0bJXUZmRmhXZORFkDi+Jl4t/1uZ75jD9bwg81bap
         xquIF9La3JrF1AJWtVlLr9SSOa+aww/tC1y+OHLkSmsL/1zifLglwuwmjq7BMWi0UmVy
         MlWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770930479; x=1771535279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOKCWCRr5YpFu/NFeMmLz1mRvSwOeviiUocMLbpIQso=;
        b=mm/k+AveEaSsP7XwF1/woZ+DqSPha9XvOKx/2mF2plIF4/Ajee60RmME3Kv+yoV33x
         BIc8iN6GbZnkPuv1waNDPYjn6OlOQLzMLmUrb3VKxBOgdO3uxq3e/Sr3YMH7MJMV1z3n
         Z1tTRjj0Zr1hl2RlGrL/eI0+O3K6TieVfQnXyjMea2KBz9UKgjrNkOy3N0wxMwy1d6HF
         ieO6K2u7v5c17+UiPrzjBJAUc5lmVwukMd/CxVgOJL/F9vknysdVnBlL3dGKo3pCI41+
         6rsprizustrHjqB3Ti3/89O0BzMnM3FckqF+HeXWwk8kH0JoEiF9nP4DqcmpSLrCfHuq
         oCBw==
X-Forwarded-Encrypted: i=1; AJvYcCUHeQQMKq5iW+TQw5XqF54837A+HaRPDq+LQNa5wfCoa2AirIGbOP3ccDWYfofFCnjHr/4T09qFAI3n@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/VNOmTff1vCIkmk00CNOaUt5rXUV5WpQXXaF9xoCJfNbCgbdh
	LpphcEXfc87Qst1I62WkOdyEN0HzrPSdzhE/KW45CXVI4Np8m1G+FvAz5u0/VOxZkxYVHsC3Q9W
	E5Srd59G0+F9O28EIL6iU8EhbcrW23Zg=
X-Gm-Gg: AZuq6aKnGOXOtMTuWIVwhxy2T55SBusXNV43rj8P2Qbqvu4gNnppDFm2crmA6I9SFOy
	F6DT8qcS0hFP/hXmLYppai8sE7nJZ4To7M0BrqWHYgDd++1OkdXQkRV8yELbwUWHj46U4AAKUHI
	rQSjpVHAWEMktHZhVPaHc9CIRVWvh2AmKS6hACHwwZMbtl/9L3IEeS07ISgliQmvuJPZpF2qXjq
	0dHDCjy0JNAq0KGN2agQF0gCe8eyrsrBzZnH4x0d5ffAxQs70RD6sEJDcEqvyEA/7tWhvRHOpMW
	I6nzFMtciOZND0XcxwLSRrvE8y8B1BVcF5Qg1ckevOR8Pe22R4mdYcGA9mNJsOYXaLzA1wzLlGx
	ec27Y56BPtRtOBd1N/jyh/Ug8BGdVD7xHDoFE7coF+OiuNdQ+6yJNysVZHNhOSQ1hENg5mSCoN5
	3Nj8c/pFx9asoVjDIrlVzi
X-Received: by 2002:a05:620a:40c3:b0:8cb:3870:5c1f with SMTP id
 af79cd13be357-8cb4087e498mr42727685a.27.1770930479083; Thu, 12 Feb 2026
 13:07:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org> <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org> <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
 <CAH2r5muf=Th_AbA7SZaQKApyvr81FMB8WF-5yZ3ihzap1swQWg@mail.gmail.com>
 <98d25ce1-1f1a-4517-89f0-8956bffaf9d3@samba.org> <CAH2r5mswN8W652Br4QQTzhtDXtXKvqea=dWVfUFF+xDYfOx6HA@mail.gmail.com>
 <28d94c9f-b85e-4746-bb08-188090409682@samba.org> <CAH2r5mtA=DdpEiyqspNG3eoyjkGajnEwoRnOyXyBimDtCND9ig@mail.gmail.com>
 <c5aef237-2a12-4be5-b917-de502780be85@samba.org>
In-Reply-To: <c5aef237-2a12-4be5-b917-de502780be85@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 15:07:46 -0600
X-Gm-Features: AZwV_QjN7rb2ho4ZyDIkXJegbI16VanyWOg-Azt6CZXpDntDSupanVJzx0e8qYM
Message-ID: <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have updated ksmbd-for-next with the first 57 patches in the
smbdirect/RDMA series.

418c4323705 (HEAD -> ksmbd-for-next, origin/ksmbd-for-next) smb:
smbdirect: let smbdirect_internal.h define pr_fmt without
SMBDIRECT_USE_INLINE_C_FILES
fbb6a3b2d26d smb: smbdirect: let smbdirect_socket.h include all
headers for used structures
ae6c9a6e0550 smb: smbdirect: introduce
smbdirect_socket_create_{kern,accepting}() and
smbdirect_socket_release()
437aba3f5a12 smb: smbdirect: introduce smbdirect_accept_connect_request()
b3ddfc3f09be smb: smbdirect: introduce smbdirect_connect[_sync]()
4ad8cf4f2959 smb: smbdirect: let
smbdirect_socket_set_initial_parameters() call
rdma_restrict_node_type()
e6da0c18d7ba smb: smbdirect: introduce
smbdirect_socket_init_{new,accepting}() and helpers
ef37f9d51034 smb: smbdirect: introduce smbdirect_socket_shutdown()
dfa0af2a16b6 smb: smbdirect: introduce smbdirect_connection_is_connected()
f85af9e7c614 smb: smbdirect: introduce smbdirect_connection_wait_for_connec=
ted()
c35cf02d82cc smb: smbdirect: introduce
smbdirect_connection_legacy_debug_proc_show()
d35a8675ea36 smb: smbdirect: introduce smbdirect_mr_io_fill_buffer_descript=
or()
4cbd37ad2e75 smb: smbdirect: introduce smbdirect_connection_negotiation_don=
e()
b6942a30409b smb: smbdirect: introduce
smbdirect_connection_send_immediate_work()
d1b71276a998 smb: smbdirect: introduce
smbdirect_connection_send_iter() and related functions
84841c14ec8a smb: smbdirect: introduce smbdirect_connection_request_keep_al=
ive()
bd3c43a9716a smb: smbdirect: introduce smbdirect_connection_grant_recv_cred=
its()
6dd5b927120f smb: smbdirect: introduce smbdirect_connection_recvmsg()
19b86a60f1f6 smb: smbdirect: introduce
smbdirect_connection_rdma_{established,event_handler}()
5a522e9a8c6d smb: smbdirect: introduce smbdirect_socket_destroy[_sync]()
ddc50831c9be smb: smbdirect: introduce smbdirect_connection_recv_io_done()
cbc524baa4bf smb: smbdirect: define SMBDIRECT_RDMA_CM_[RNR_]RETRY
5452fd00c3c3 smb: smbdirect: define SMBDIRECT_MIN_{RECEIVE,FRAGMENTED}_SIZE
5ab0987c492e smb: smbdirect: introduce smbdirect_rw.c with server rw code
1fed7d7a575b smb: smbdirect: introduce smbdirect_mr.c with client mr code
519897951f16 smb: smbdirect: introduce smbdirect_socket_wait_for_credits()
ff104281df37 smb: smbdirect: introduce smbdirect_get_buf_page_count()
e185a680089a smb: smbdirect: split out smbdirect_connection_recv_io_refill(=
)
09c02027a5ac smb: smbdirect: introduce
smbdirect_connection_recv_io_refill_work()
d42c83ba4b83 smb: smbdirect: introduce smbdirect_connection_post_recv_io()
f2f3bb3d9b18 smb: smbdirect: introduce
smbdirect_connection_{create,destroy}_qp()
12139caae21f smb: smbdirect: introduce
smbdirect_connection_negotiate_rdma_resources()
30148e9426b8 smb: smbdirect: introduce smbdirect_connection_qp_event_handle=
r()
9d6ebcaad731 smb: smbdirect: introduce smbdirect_map_sges_from_iter()
and helper functions
dee0c074b3a0 smb: smbdirect: introduce
smbdirect_connection_{create,destroy}_mem_pools()
28b1dedc499d smb: smbdirect: introduce smbdirect_connection_send_io_done()
bbbd815fdc94 smb: smbdirect: introduce
smbdirect_connection_{alloc,free}_send_io()
e1ff37aac3de smb: smbdirect: introduce
smbdirect_socket.{send,recv}_io.mem.gfp_mask
cbcf99b37f2d smb: smbdirect: introduce smbdirect_frwr_is_supported()
67738ec11efd smb: smbdirect: set SMBDIRECT_KEEPALIVE_NONE before
disable_delayed_work(&sc->idle.timer_work);
3dc5533c82f1 smb: smbdirect: introduce smbdirect_connection_idle_timer_work=
()
754d0caee03e smb: smbdirect: introduce
smbdirect_connection_reassembly_{append,first}_recv_io()
8ac22b59de12 smb: smbdirect: introduce smbdirect_connection_{get,put}_recv_=
io()
084df3a8fff8 smb: smbdirect: introduce smbdirect_connection.c to be filled
38fc1ca14df1 smb: smbdirect: introduce
smbdirect_socket_schedule_cleanup[{_lvl,_status}]()
4c9193a71b42 smb: smbdirect: introduce smbdirect_socket_cleanup_work()
37cdd6f6b78b smb: smbdirect: introduce smbdirect_socket_wake_up_all()
d393bc165a56 smb: smbdirect: introduce smbdirect_socket_set_logging()
e40786a49a70 smb: smbdirect: introduce smbdirect_socket_prepare_create()
cd1901e4253f smb: smbdirect: introduce smbdirect_socket.c to be filled
60a8be543197 smb: server: include smbdirect_all_c_files.c
c2edeca18a48 smb: client: include smbdirect_all_c_files.c
04bdb6fe7fab smb: smbdirect: introduce smbdirect_internal.h
8cddb86e72fc smb: smbdirect: introduce smbdirect_all_c_files.c
54b3a5306dca smb: smbdirect: add some logging to
SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
7f492e5767f9 smb: smbdirect: introduce smbdirect_socket.logging infrastruct=
ure
e1b49deab6cb smb: smbdirect: let smbdirect.h include #include <linux/types.=
h>
d53f4d93f3d6 Merge tag 'v7.0-rc-part1-ksmbd-and-smbdirect-fixes' of
git://git.samba.org/ksmbd

On Thu, Feb 12, 2026 at 3:05=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 12.02.26 um 22:01 schrieb Steve French:
> > I have updated patch 33 and 55 (see attached) with the checkpatch sugge=
stion
>
> Thanks!
>
> > On Thu, Feb 12, 2026 at 2:45=E2=80=AFPM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> Am 12.02.26 um 21:40 schrieb Steve French:
> >>> Should we fixup patch 33 in your series to address the warning:
> >>>
> >>> 145/0033-smb-smbdirect-introduce-smbdirect_mr.c-with-client-m.patch
> >>> -------------------------------------------------------------------
> >>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updat=
ing?
> >>> #45:
> >>> new file mode 100644
> >>>
> >>> WARNING: Prefer kzalloc_obj over kzalloc with sizeof
> >>> #84: FILE: fs/smb/common/smbdirect/smbdirect_mr.c:35:
> >>> + mr =3D kzalloc(sizeof(*mr), GFP_KERNEL);
> >>
> >> If you want.
> >>
> >> kzalloc_obj was just recently added and the code is mostly
> >> copy and paste from the client code.
> >>
> >
> >
>


--=20
Thanks,

Steve
