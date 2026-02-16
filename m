Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2084F1A9F88
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 01:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771205068; cv=pass; b=MIkmwjJ1F59urL0lgzuse9A9f9VzB1dyRFu+RW0qaT8zH9/8YWFuUsxy+aHUReOdPsBAVqOCysMHS+G3T3UnHLhOR5jKSYZxrB9J8z/h0M60T0D2QT/xbbp4R8UkZ+WqhAGrStNDvsUZGvPo1QmvE/ZATavuQfegSdM1fIRQTu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771205068; c=relaxed/simple;
	bh=3GRdYrtfICOp81Qtxkew9CTPrRIqaC3/5SV3ZY3ODiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oW9pPtNGEy7eeRnr1A9mm+6jyVCvj1DCSSc0xNhuGGf+s0NxbdPrSRamo7yp2Zo8UbdXnr6BGbbqQvSl9+TcGnHRAVd5TnCUX+ypLPqMFfVjpyZsSx7ZLns2B59MOQXWkBmUPGMB2VcHrooGffPvDleBWfnSHzkpb0/p9dz3vTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxWe6RpI; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxWe6RpI"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-896fb37d1f0so61930726d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 17:24:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771205066; cv=none;
        d=google.com; s=arc-20240605;
        b=AX/tZa0QbuMKhNFhk8tMa///EIVEXTQd6RjlWwHmVTOTZNosxdlwfNOKKBuK6wA9oR
         UCzz/Xe+nufmeQ6fGw37Jv6hm9qHavDzzaCIlsrr0foll8ydFvisybA4or0HPdGY2FNn
         DmVer37E594WRu+vICAdP1USnSTSRLr/2jDQF3TYGCxsnBmSfkB9mEhrn0QFGpItAmEm
         tTIvzLu06tZOLn/B3rR7U7RLlqm1BRGe8swbxxz75xPz8KnQGRTwtfKAZ0rnw1dvArh6
         8/xeyLsMXnxwKpJ1liR/1uVee1nwZIow2tjzSRvRGDfJCIpULug0hCFk4amyLniB5n74
         +x7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GlDdzuDqmGo5CWEefjRwn1tLcN3C2Vee7t1D30wE0I8=;
        fh=S0TO1xQZ9y7IlcVmAgeMhb59npouVUVfY6Ko9uoPx+M=;
        b=SMXJserlGOBql0u15joDTyuziToR8v9aUpaDFpNN31bn8rcCUT5g4r+t0eEyK8sahW
         ptdpEGlQoUU0KaZ7p0eD7dnQLCv41O+UayBSWDhnfaJFjF2BapXxHSlRORdyhGzuSCK6
         i3WyNnNsKjv5vczn/EE1tCGAW8TqW0eTHHJgLWFBMC/u3XI23cwQlGpszzyi6nAdhuE6
         qB1+sC/a8G/lqESu7HQp0MqfgFr8e+ePRi+5vohADx7I7xCxbOgpWuvXkiEFSIhbE7oe
         VCxU8x4wBEEnQmeVMsJ936dfKs2IFkcjIILrI1Upp98phiOef/CW+kkZVkO7vTZ2T/Vi
         hfxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771205066; x=1771809866; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GlDdzuDqmGo5CWEefjRwn1tLcN3C2Vee7t1D30wE0I8=;
        b=HxWe6RpIPW+tbDcoWHks7nwS9fy8sl3C2s9iljlcA8BhbwCHkN/2gehV/1Kz3YDw+o
         He4KG7rS1UKB80UEHn08MjI1kAGwVio45b0eJiIWq9W65p5Cvpk/MjQp4zzOPjNe4Ruk
         Ypse7490+j5DZ05L9Dq20XuaoFBGwgTDvyNyJkTKXl6CqizL7l/WvMm4Kc52Y/tK5BOz
         pyXolIoAfemhyjtc0W0aU6x1lkAmXe0+l5I4iu3d33v1Gzk55jgFse9mTHUXBPTwi++P
         1I8qSRY7dGeDMyJ/06FB8R7Ql3qi7TfHPptvy2R5kNfj94Gs2D/s1/qTFrjAA09Gr1Xz
         SK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771205066; x=1771809866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GlDdzuDqmGo5CWEefjRwn1tLcN3C2Vee7t1D30wE0I8=;
        b=uK+IP9CmK7TcmBoXwEaGuKyvd+PJYMm2KRjFBmRRO7tM1ivlpWqK8W+6o8TRzwLrcG
         el2B1rQ19UG03vpyDVsCURZQDMCRvc69AkOQHAg6QJPmm2YUD2/pg1/+T5tQtCMyKg3T
         rA8bsJw73yQm9OQCnNlJ4fclxDlQPqldNuujpXc/MdUZPXkCRt0Y+Ei91D9mbX0yeei5
         LL2kkGNGnkx1Y3BTOKXnj3CDD14iPJ7JO/DjeC9FBRs9/XIZdCYLtVo52Qru01FMUV5G
         YpHyiOnGMdNbydpCJVWrSfu5QQtHNNhRsPNsHX7CfRtH1T09v0FdKVXi0C0tGw0pYEh0
         ow9Q==
X-Forwarded-Encrypted: i=1; AJvYcCX30Xb2MHqZ/zyL6eqeHztwjvBzzwZDpJtquQaipMl/sF/Bq1ihxoF91Tl3Nd5nKYFok7JAKYuQj0jS@vger.kernel.org
X-Gm-Message-State: AOJu0YyLy8HNe/EOSrsFbd6p3FCet0YpWrshvqetqRyiEe0++C1zBnsO
	XEtkBmSx5K/n48yh2NWmaQf8AOKo/iHqpsFss8QwD87iQkB0ylgekasw2Xzyxx6L/rxD9DCsRYB
	y5GxoIEGLk5ncDa03fp8hZeNHd6EsWhU=
X-Gm-Gg: AZuq6aIBzUoiLJA2mxJMnMfQx03YQibhpuSAgMGfeL9PQDvnSH4OaqiR8oUT/8wEYBb
	6jP3j356XIHhqg4aCcRYK7cfhrSNephTusvpFYpLJs8fF6AsZrUWFe/IqzilxJFkQTjXowpHBoV
	O5/ooIVIy0OQJ1MjyPYWRHseIw9xgNrgo8BBThA6Ph1HxaNREFi3+b3QjMbSrKQIPNzK0b1qL0s
	qcb41hIqOjXrUJLmP18n9mQd2G7F6xzQicWwQyJyPUPA4uCwOIz0x2EH7mmGTND1l1x4Vl8WrK8
	FWuFmgWIAfeNTvIuyX32D4fUvPMbRCMMBxT3p8OH0URKlp+IYoXJcy7sFlpYHFocF+qTF9BFGQj
	JsjtcrK8pkJGPBN4EQB8eokryr0gCDJrplW32KekCk0982T+PjRKXS1V/SJn+VJ8/8B4Ji/fcZc
	FcA/HLE/KUQSJS7Defs5qDsxQ64ksZ+v91
X-Received: by 2002:a05:6214:5196:b0:894:823e:7708 with SMTP id
 6a1803df08f44-897404e5b37mr95098226d6.63.1771205066061; Sun, 15 Feb 2026
 17:24:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205010012.2011764-1-aadityakansal390@gmail.com>
 <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com> <CAH2r5mt+608DDhj93Fa55PZ_-1yfJZTa5v4LQ-D48V9ZYPDJUA@mail.gmail.com>
 <edd75933-91b7-428e-b88b-dcc4e8bdcae7@gmail.com> <CAH2r5msF43X+Gm-7eY3m=wyf+K6Hwzxx0522QrqD7VSWeJJwog@mail.gmail.com>
 <f11adc2a-2d97-43ed-b7ff-e6480449eb95@gmail.com>
In-Reply-To: <f11adc2a-2d97-43ed-b7ff-e6480449eb95@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 15 Feb 2026 19:24:14 -0600
X-Gm-Features: AaiRm52WvZ7C7yq7p7MhLYsimwLXKvlDJuwNGAgByN9OMCzF8SvIx6Hc9d4QSnI
Message-ID: <CAH2r5msv8TJj9-X5t83z58dwr-BjtNx6=mxCjkFMjGb-CDQuTA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: terminate session upon failed client
 required signing
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2026 at 4:42=E2=80=AFPM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
>
>
> On 2/16/26 02:38, Steve French wrote:
> > On Sun, Feb 15, 2026 at 1:23=E2=80=AFPM Aaditya Kansal
> > <aadityakansal390@gmail.com> wrote:
> >>
> >> On 2/16/26 00:01, Steve French wrote:
> >>> On Sun, Feb 15, 2026 at 7:17=E2=80=AFAM Aaditya Kansal
> >>> <aadityakansal390@gmail.com> wrote:
> >>>>
> >>>> On 2/5/26 06:30, Aaditya Kansal wrote:
> >>>>> Currently, when smb signature verification fails, the behaviour is =
to log
> >>>>> the failure without any action to terminate the session.
> >>>>>
> >>>>> Call cifs_reconnect() when client required signature verification f=
ails.
> >>>>> Otherwise, log the error without reconnecting.
> >>>>>
> >>>>> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> >>>>> ---
> >>>>> Changes in v2:
> >>>>> - reconnect only triggered when client required signature verificat=
ion fails
> >>>>> ---
> >>>>>  fs/smb/client/cifstransport.c | 10 ++++++++--
> >>>>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstran=
sport.c
> >>>>> index 28d1cee90625..6c1fbf0bef6d 100644
> >>>>> --- a/fs/smb/client/cifstransport.c
> >>>>> +++ b/fs/smb/client/cifstransport.c
> >>>>> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, s=
truct TCP_Server_Info *server,
> >>>>>
> >>>>>               iov[0].iov_base =3D mid->resp_buf;
> >>>>>               iov[0].iov_len =3D len;
> >>>>> -             /* FIXME: add code to kill session */
> >>>>> +
> >>>>>               rc =3D cifs_verify_signature(&rqst, server,
> >>>>>                                          mid->sequence_number);
> >>>>> -             if (rc)
> >>>>> +             if (rc) {
> >>>>>                       cifs_server_dbg(VFS, "SMB signature verificat=
ion returned error =3D %d\n",
> >>>>>                                rc);
> >>>>> +
> >>>>> +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRE=
D)) {
> >>>>> +                             cifs_reconnect(server, true);
> >>>>> +                             return rc;
> >>>>> +                     }
> >>>>> +             }
> >>>>>       }
> >>>>>
> >>>>>       /* BB special case reconnect tid and uid here? */
> >>>> Hi, I am writing this as a ping for this patch. Thanks
> >>> merged into cifs-2.6.git for-next but had to rebase it to merge into
> >>> current code.
> >>>
> >>> Have you verified the behavior of default (smb3.1.1) mounts as well?
> >>>
> >> Thank you. Yes, I have checked it for the default version.
> >> Tested for both client required and server required signature verifica=
tion.
> > You were able to verify (simulate) it as well for default ie SMB3.1.1
> > (not just for SMB1
> > which this patch fixes), and no changes needed for SMB3.1.1?
> >
> >
> Yes, I verified for default version (3.1.1). First I set signing
> required option on server side,
> then I set the sign flag on client side. SMB3.1.1 mounts with no issues.

How were you able to simulate bad signatures being sent from the server
for SMB3.1.1? and for SMB1?

--=20
Thanks,

Steve
