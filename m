From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: SMB2 protocol support for CIFS Linux kernel module
Date: Thu, 20 Oct 2011 19:27:06 +0400
Message-ID: <CAKywueSJoApMc8RrDO-nfd64FWdNG_Zdw2-Mse01wK3B0h+VzA@mail.gmail.com>
References: <CAKywueQV4QS5FZiSr8zkeH6tpUokuN4a-yKn5mmZ7F8F_V8_mA@mail.gmail.com>
	<20111020112058.185cae5e@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111020112058.185cae5e@barsoom.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/10/20 Jeff Layton <jlayton@samba.org>:
> On Fri, 14 Oct 2011 13:31:10 +0400
> Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
>> Hi all!
>>
>> I rebased my cifs-3.2-current branch on top of current
>> cifs-2.6/master. It includes all patches (lock caching + smb2 patches)
>> I want to get into 3.2 release.
>>
>> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-3.2-current
>>
>> Comments are welcome!
>>
>> --
>> Best regards,
>> Pavel Shilovsky.
>
> I started looking over them, but it's hard to comment since almost all
> of them haven't been sent to the list and there's nothing to reply to.
>
> Would it be possible to send this to the list in one or more patchsets
> so it can be reviewed like any other series?
>
> Thanks,
> --
> Jeff Layton <jlayton@samba.org>
>

Thanks! I will split it into several patchset and post to the list in
this case. The last version of patches is here:

http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-3.2-aread

-- 
Best regards,
Pavel Shilovsky.
