Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EFB1B2EE0
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724262163; cv=none; b=dRPXgphnWt0PylcgT6BhbBlCsuomuJiXg89YRNEFWm8jD4xxw5Af4w3TBPO34gmbqXmJEtVzd03Z8HxnlxIQdpFgVF7QmOTvUOjeBptYVsX1rInfY0DE05yE+QGlvOZSpI4VGOtJk+KcRxiDtNybGBGRcVc7O9y8zHJKdKTUy54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724262163; c=relaxed/simple;
	bh=hocvFVUoUNKNhs9f8EwuZiQJ+zY5b/yYKsZcT71mQDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKThnA24gc9Luqh7ics9h4wu24DWrCK0K4xJlMWlWPn6hw/+Pij//RJaxYduOAq3yqpTPLj/2k9ZEomKNvwfgMxODoaxdAIsvxSD5I1f6SzSx/ANOh1RPsbfSp0lPt2oT9XpQy59b1vEstQRhHj1zIfkWHqIZkIzEc6annNf6H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuT0RdvA; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuT0RdvA"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e117059666eso6708823276.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 10:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724262161; x=1724866961; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ddit2z2D6bqAxGYRSrhpsifHytuj1Ae5oJXT23/VeCA=;
        b=kuT0RdvAZ/wbU5Xg0m9tLZoc3V3tU/Fkabl7xSGrTZR/Qcv0nN/iS6Kqo3XZDLhPfZ
         F5dy/I++u5K0AjzwGLvViWIOAL+Nc8lB9AnxZAPI5vyd4HWJS2ut/F3+XW6Pw6q11I2x
         aG3o8R8d5H2GL1fB6pTKyPPxQaXhK8PVkzuBqhUFd3FVbVoSyq6jOCZjvcyHbiBWv+3O
         yj+y7iA35Ncu8bEb/zCkO0WGNUH4hG/hEOC38EMOpFV2aseH5H/fcFjy5Ba/lubLyT2k
         heVQ6vaROPAureyj782EuHYc6iAApzkmMaVhP8un1tI7Fllx5sM0X08YAuk7znLNWsDo
         CbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724262161; x=1724866961;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ddit2z2D6bqAxGYRSrhpsifHytuj1Ae5oJXT23/VeCA=;
        b=ruBi9OieaVLbU5gn1LPa1Zd3DckdjeuB6NYQoPG4umZLMhQh1Cu0n3/CRwTimPRM46
         8+UOys1ZOKaRjsvF0XSNcjSl8BTZ8OwhS84Z5Po2+jo8tsh5/lOf3mvGp32jE04vYCmw
         bvt02C2DKxx+zkvDlkdOHKC8h/Hj78F8JQzzXaVoxpp6usYizMgAAobz3KnF+w35XjRr
         0KMTJf4+rGSpUMxLsNIlr+JfYyjuCdh3CyMzkiNVkIzC+65618xd8ktUDxGkEhFAAWqB
         cEWV83Oz8KuxqiTe0bhZwGgJzIfWJ4wB3Pcu0I3F7nfunkHf6kdUmcgChFHt+b458+2s
         NLAw==
X-Forwarded-Encrypted: i=1; AJvYcCX+12v1MO+ixEEbBuIOwlApcXSBC8Nl+Su5nUQu5eBeoTZPAhWh9He+Gh9/WBcV8QZqhZ3VL3NwiOUO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq8qlXPc/rS7HXAQ1C0xfgbaBz7Dhvk5vnhG83JpBejf5XJ/nh
	I34hTQxVcy7I//sdPwq+Rty+eauee592eue+srLyaG7fQrmZtpwO+0mxeUjSU9I+Y+k+libVWvT
	6M0Fuy4mP9tFU0OvduD8ZOio+yEU=
X-Google-Smtp-Source: AGHT+IEZAaXVFQvbWEYSLVkJTQx73yXn/I9YDH2FivJhnfFKkLnBe1fsty1F4KtsoyiRb2Yn4abdZiPa/KaqDtKyV9Q=
X-Received: by 2002:a05:6902:150d:b0:e16:5343:ba4e with SMTP id
 3f1490d57ef6-e166517ebbfmr4143903276.0.1724262160623; Wed, 21 Aug 2024
 10:42:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com> <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
 <CAACuyFU2va16OGn7_i-Ur-TEic7AW7pQj3c3xrPT1P2HJts9bg@mail.gmail.com>
In-Reply-To: <CAACuyFU2va16OGn7_i-Ur-TEic7AW7pQj3c3xrPT1P2HJts9bg@mail.gmail.com>
From: Anthony Nandaa <profnandaa@gmail.com>
Date: Wed, 21 Aug 2024 20:42:27 +0300
Message-ID: <CAACuyFWrejfaYiFU8REzj=uTFg88qi7guL1oQg3zqnDWY-vR_w@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Marc <1marc1@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I have now tested the patch.

On Wed, 21 Aug 2024 at 18:55, Anthony Nandaa <profnandaa@gmail.com> wrote:
>
> I can help with this. Marc, if you can help me with the minimal repro steps, is OneDrive needed?
>
>
> On Wed, Aug 21, 2024, 15:15 Marc <1marc1@gmail.com> wrote:
>>
>> Happy to help and assist where I can, but I have no idea how I would
>> try this updated code. I think it involves compiling a kernel and
>> applying the patch to it. This is not something I have ever done or
>> have an idea on how to go about it.
>>
>>
>> Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.com>:
>> >
>> > Marc <1marc1@gmail.com> writes:
>> >
>> > > This has been working great for many years. Yesterday, this stopped
>> > > working. When I tried mounting the share, I would get the following
>> > > error: "mount error(95): Operation not supported". In dmesg I see:
>> > > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
>> > > "VFS: cifs_read_super: get root inode failed".
>> >
>> > Can you try the following changes?  Thanks.
>> >
I see that the patch is in
for-next@80dd92d6ac7d1bc4b95d0a9f4d7730fe5ee42162, so I have just used
that to build a new module.

I created a share from one of the directories in my OneDrive:

    sudo mount -t cifs //WIN-31GSG2M9E6N/Users/Usa/OneDrive/Shuttle
/mnt/shuttle -o username=...,password=...

Before the patch, the mounting was failing but after building with the
patch, it mounted successfully.

Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: parse_reparse_point:
unhandled reparse tag: 0x9000601a
Aug 21 17:25:32 ubuntu-test-2 kernel: CIFS: VFS: cifs_read_super: get
root inode failed <~~~~ FAIL
...
Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: Attempting to mount
//WIN-31GSG2M9E6N/Users/Administrator/OneDrive/Shuttle
...
Aug 21 17:31:22 ubuntu-test-2 kernel: CIFS: VFS:
\\WIN-31GSG2M9E6N\Users unhandled reparse tag: 0x9000601a
^^^ SUCCESS.

>> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
>> > index 689d8a506d45..48c27581ec51 100644
>> > --- a/fs/smb/client/reparse.c
>> > +++ b/fs/smb/client/reparse.c
>> > @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>> >                         u32 plen, struct cifs_sb_info *cifs_sb,
>> >                         bool unicode, struct cifs_open_info_data *data)
>> >  {
>> > +       struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>> > +
>> >         data->reparse.buf = buf;
>> >
>> >         /* See MS-FSCC 2.1.2 */
>> > @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>> >         case IO_REPARSE_TAG_LX_FIFO:
>> >         case IO_REPARSE_TAG_LX_CHR:
>> >         case IO_REPARSE_TAG_LX_BLK:
>> > -               return 0;
>> > +               break;
>> >         default:
>> > -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
>> > -                        __func__, le32_to_cpu(buf->ReparseTag));
>> > -               return -EOPNOTSUPP;
>> > +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
>> > +                             le32_to_cpu(buf->ReparseTag));
>> > +               break;
>> >         }
>> > +       return 0;
>> >  }
>> >
>> >  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
>>


-- 
___
Nandaa Anthony
