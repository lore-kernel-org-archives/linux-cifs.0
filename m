From: Jeff Layton <jlayton@samba.org>
Subject: Re: SMB2 protocol support for CIFS Linux kernel module
Date: Thu, 20 Oct 2011 11:20:58 -0400
Message-ID: <20111020112058.185cae5e@barsoom.rdu.redhat.com>
References: <CAKywueQV4QS5FZiSr8zkeH6tpUokuN4a-yKn5mmZ7F8F_V8_mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAKywueQV4QS5FZiSr8zkeH6tpUokuN4a-yKn5mmZ7F8F_V8_mA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 14 Oct 2011 13:31:10 +0400
Pavel Shilovsky <piastryyy@gmail.com> wrote:

> Hi all!
> 
> I rebased my cifs-3.2-current branch on top of current
> cifs-2.6/master. It includes all patches (lock caching + smb2 patches)
> I want to get into 3.2 release.
> 
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/cifs-3.2-current
> 
> Comments are welcome!
> 
> -- 
> Best regards,
> Pavel Shilovsky.

I started looking over them, but it's hard to comment since almost all
of them haven't been sent to the list and there's nothing to reply to.

Would it be possible to send this to the list in one or more patchsets
so it can be reviewed like any other series?

Thanks,
-- 
Jeff Layton <jlayton@samba.org>
