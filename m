From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: My changes to use socket callbacks have worked well enough to
 mount a Samba-SMB1-based File system
Date: Thu, 20 Sep 2012 16:35:02 -0700
Message-ID: <20120920163502.29654d25@corrin.poochiereds.net>
References: <CACyXjPwp+dNPLk2TuUyeuuPrwqDZQcFV5W+RK6++fRaQsaEn+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPwp+dNPLk2TuUyeuuPrwqDZQcFV5W+RK6++fRaQsaEn+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Sep 2012 15:49:07 -0700
Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi Folks,
> 
> So, here is the evidence:
> 
> ---------------------------------------------
> [root@richards-centos62-01 cifs-2.6]# mount -t cifs richards-sw-01
> /mnt -o unc=//richards-sw-01\\backup,ip=10.250.209.113,user=administrator,pass=St0r@ge!
> [root@richards-centos62-01 cifs-2.6]# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/mapper/vg_storage09-lv_root
>                       52324100   5115200  44587460  11% /
> tmpfs                  4097628         0   4097628   0% /dev/shm
> /dev/sda1               508644     88730    394314  19% /boot
> /dev/mapper/vg_storage09-lv_home
>                      460511448  53195152 384264420  13% /home
> richards-sw-01       160432112   2911480 157520632   2% /mnt
> [root@richards-centos62-01 cifs-2.6]# ls /mnt/
> [root@richards-centos62-01 cifs-2.6]#
> ----------------------------------------------
> 
> I need to clean up these changes and handle error cases and get it
> working against a more recent tree ... but it is taking shape.
> 

Nice! Sounds like a great start to cleaning up some of the hairiest
code in cifs.ko. My hat's off to you!

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
