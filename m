From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] smb3: fix large reads on encrypted connections
Date: Sun, 6 Jan 2019 10:41:50 -0600
Message-ID: <CAH2r5ms3sxLLaUGOzaAL8YCMZswk8J6=MwtjjDPB_f78r49GEw@mail.gmail.com>
References: <20190106105305.GB2964@darth.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>
To: Sebastian Kemper <sebastian_ml@gmx.net>,
        Stable <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190106105305.GB2964@darth.lan>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Jan 6, 2019 at 4:58 AM Sebastian Kemper <sebastian_ml@gmx.net> wrote:
> Sorry for probably breaking the thread. This is really in reply to Paul
> Aubrich's patch titled "smb3: fix large reads on encrypted connections".

> I browsed linux-cifs and found Paul's patch. With the patch applied the
> problem is gone, kernel 4.19 works like 4.9 did without encryption.
>
> The patch title suggests that only large reads are not working. Well,
> considering the cutoff is between 13K and 17K I'd say that encryption on
> 4.19 for cifs can be considered broken without this patch. It'd be cool
> if this could make it to stable kernels pronto.

Yes - it is a a very important patch, and is merged in and marked for stable
(for 4.19 and 4.20 kernels). Hopefully can be included soon.

The good news though is that with the improved test automation that
Paulo/Aurelien/Ronnie have been doing, we have added more to
the automated xfstests run before checkin and more importantly
added various different mount configrations that are much
broader (used to be only a very small set that ran) and so would have
caught this (and also other regressions that had made it through over the
past couple years).

Now our next challenge is figuring out how to get automated tests for smb3
to run reasonably regularly against some of the stable kernels and also against
the full backports of cifs.ko to earlier kernels etc. which some need to get the
many security, performance and functional improvements over the past year.


-- 
Thanks,

Steve
