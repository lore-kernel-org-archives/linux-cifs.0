From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Wed, 3 Jan 2018 16:44:59 -0600
Message-ID: <CAH2r5mvgtC3Y_aLxk7-_R8E=ohR1LoFSkiqZZ6rhn9azXY05xw@mail.gmail.com>
References: <20180104093359.4e012f2f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180104093359.4e012f2f@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I don't see this with gcc 5.4

Stephen,
Harmless to initialize flags here ... even if unneeded ... so if it
makes your life easier I don't mind initializes to 0.  Let me know.
Wonder why it doesn't generate the warning on the various other places
in the fs that do the same thing?

On Wed, Jan 3, 2018 at 4:33 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> In file included from include/linux/seqlock.h:36:0,
>                  from include/linux/time.h:6,
>                  from include/linux/stat.h:19,
>                  from include/linux/module.h:10,
>                  from fs/cifs/smbdirect.c:16:
> fs/cifs/smbdirect.c: In function 'smbd_recv_buf':
> include/linux/spinlock.h:260:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    _raw_spin_unlock_irqrestore(lock, flags); \
>    ^
> fs/cifs/smbdirect.c:1865:16: note: 'flags' was declared here
>   unsigned long flags;
>                 ^
>
> Introduced by commit
>
>   ac69f66e54ca ("CIFS: SMBD: Implement function to receive data via RDMA receive")
>
> OK, this is a false positive, but annoying.
>
> I am using gcc 5.2.0.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
