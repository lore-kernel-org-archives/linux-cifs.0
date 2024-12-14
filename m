Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A15218AE2
	for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 02:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734143641; cv=none; b=fZXwydf3IR7uNJmlpGIx+4p30tMuGtW/kfnPf2J1ibT+OF2PPt3QlYVbIn7Gv4xEeBeL98QwPPiRyIaugMtYmD1Za8rQ9xZN1aOG/HzPGebnWqbThGUS0UBtZvjBwArSODD6g+xVU6L/bGSdMtPyntDUayAwOUXNXhf5nVjaG8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734143641; c=relaxed/simple;
	bh=BAkad/ISKgWCzgq3rpWiTHzdloGk27UdqP7cEqUE+AA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Na0xu5mJe23N2B/+3xZQ9Vfnhun5Pqc7y9QDEGneFtBCeOsrARKTc03KkgP6cjXz1kxKljkQY5p3jZcsymT7H/qb55/WRszR7i++gpgo5RIgs37B/RJLMMClwV4A+y7TkgK+U+mAbaGuMEKzedELcubzhGU0Xh3hIKuCun30yvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7EmnpCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7EmnpCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4CEC4CED7
	for <linux-cifs@vger.kernel.org>; Sat, 14 Dec 2024 02:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734143641;
	bh=BAkad/ISKgWCzgq3rpWiTHzdloGk27UdqP7cEqUE+AA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J7EmnpCCc3fbCtRw9JfcJyALvf437aoZDS33PV+RgBQFYjoYJdg4OWp5l87nYD2QG
	 dIjjwDgV5SRotJhcW02HnyILLWKrHSgUD+D/ZJXyeQ6jJzq/w/YNHfcXI4Noy2YVDT
	 R2VBbxYP+gL0bpthjsFk2JyMXo0oxPOFcecKWUYTvGol+5stCn8EXSbqFDBSy5QQDp
	 c2ROCBTsKU9zruoalcYRQ7ks7nRg/RSUCO3eNtvvZEdoEv2AxTaLbCD16g1bxF7dtU
	 qspfy95W/UU5qdoQvrsjPzi52a7F4mpOf7LHYnzqTE4Ku4PMn6+e4PBc0TKavpW2e7
	 T7G/ROyj18asw==
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3eb98b3b63dso569662b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 18:34:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWp0evnbQtg2ZITRiMV3uaA7JJSF7sJjj0Q0aVasjyWdK9YwS81B+5RHBJD1ppEqEfOQcOADlZy/0Gt@vger.kernel.org
X-Gm-Message-State: AOJu0YynXQhVqKN/kKd1FIGGhS1fUZalWS3YL5jGiUrBu+ibPq5z1FWa
	o1fDkEh+pOTVGlK6KKFAbl8mYIhtjN8ax4Dd1Y13dmMiDqXMtAxgxwQkalykWG+bYf3u0D8EIrB
	YCNMhqCRdnCnfKot3auTxVDcYO1w=
X-Google-Smtp-Source: AGHT+IHoLD8txjaRR6WBkPALY16IIamw4qf25ApCWZNCSSCYKmOgwxJW+S3QwirC8mlZM7tjr2eq73N/A1ASBWVtBKU=
X-Received: by 2002:a05:6808:14c8:b0:3eb:8e20:bb8f with SMTP id
 5614622812f47-3eba6997e8amr2456230b6e.42.1734143640159; Fri, 13 Dec 2024
 18:34:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025072356.56093-1-wenjia@linux.ibm.com> <20241027201857.GA1615717@unreal>
 <8d17b403-aefa-4f36-a913-7ace41cf2551@linux.ibm.com> <20241105112313.GE311159@unreal>
 <20241106102439.4ca5effc.pasic@linux.ibm.com> <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com> <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal> <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
In-Reply-To: <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 14 Dec 2024 11:33:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
Message-ID: <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Kangjing Huang <huangkangjing@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 8:07=E2=80=AFPM Kangjing Huang <huangkangjing@gmail=
.com> wrote:
>
> Hi there,
>
> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
> as mentioned in the thread.
>
> I am working on modifying the patch to take care of the layering
> violation. The original patch was meant to fix an issue with ksmbd,
> where an IPoIB netdev was not recognized as RDMA-capable. The original
> version of the capability evaluation tries to match each netdev to
> ib_device by calling get_netdev in ib verbs. However this only works
> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
> and since with IPoIB it is the other way around (netdev is the upper
> layer of ib_device), get_netdev won't work anymore.
>
> I tried to replicate the behavior of device matching reversely in the
> original version of my patch using GID, which ended up as the layering
> violation. However I am unaware of any exported functions from the
> IPoIB driver that could do the reverse lookup from netdev to the lower
> layer ib_device. Actually it seems that the IPoIB driver does not have
> any exported symbols at all.
>
> It might be that the device matching in reverse just does not make any
> sense and does not need to be done at all. As long as it is an IPoIB
> device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to just
> automatically assume it is RDMA-capable. I am not 100% sure about this
> though.
Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
How about assuming it's RDMA-capable and allowing users to turn
RDMA-capable on/off via sysfs?

Thanks!
>
> I am uncertain about how to proceed at this point and would like to
> know your thoughts and opinions on this.
>
> Thanks,
> Kangjing
>
> On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kernel.org> =
wrote:
> >
> > On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> > > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux.ibm.c=
om> wrote:
> > > >
> > > > On Wed, 6 Nov 2024 15:59:10 +0200
> > > > Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of RDMA =
core code?
> > > > >
> > > > > RDMA core code is drivers/infiniband/core/*.
> > > >
> > > > Understood. So this is a violation of the no direct access to the
> > > > callbacks rule.
> > > >
> > > > >
> > > > > > I would guess it is not, and I would not actually mind sending =
a patch
> > > > > > but I have trouble figuring out the logic behind  commit ecce70=
cf17d9
> > > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
> > > > > > ksmbd_rdma_capable_netdev()").
> > > > >
> > > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM to a=
void
> > > > > GID, netdev and fabric complexity.
> > > >
> > > > I'm not familiar enough with either of the subsystems. Based on you=
r
> > > > answer my guess is that it ain't outright bugous but still a layeri=
ng
> > > > violation. Copying linux-cifs@vger.kernel.org so that
> > > > the smb are aware.
> > > Could you please elaborate what the violation is ?
> >
> > There are many, but the most screaming is that ksmbd has logic to
> > differentiate IPoIB devices. These devices are pure netdev devices
> > and should be treated like that. ULPs should treat them exactly
> > as they treat netdev devices.
> >
> > > I would also appreciate it if you could suggest to me how to fix this=
.
> > >
> > > Thanks.
> > > >
> > > > Thank you very much for all the explanations!
> > > >
> > > > Regards,
> > > > Halil
> > > >
>
>
>
> --
> Kangjing "Chaser" Huang
