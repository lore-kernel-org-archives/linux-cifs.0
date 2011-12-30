From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs speed problems
Date: Fri, 30 Dec 2011 11:56:45 -0600
Message-ID: <CAH2r5muUWrfjk=TnzRZVr=5MfSjN0df0BG90VxVs3tcZNeDi_w@mail.gmail.com>
References: <4EFDE456.5040108@inf.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFDE456.5040108-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs speeds had been pretty good for multiple processes doing i/o the
server (something like dbench with multiple processes will do
reasonably well compared to alternatives), but did not implement async
read or write dispatch (for the same file) until more recently.

Starting with 3.0 kernels (due to Jeff's async write patches) my
testing gets wire speeds (near 1Gb/sec) on write (copy to the server).
For 3.1 kernels (due to the async read patches) my testing gets wire
speeds (near 1Gb/sec) on read (copy from the server).

Not sure the distro backport plans for these but most current Fedora
etc. should benefit from these.

On Fri, Dec 30, 2011 at 10:18 AM, Benjamin Schindler
<bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org> wrote:
>
> Hi
>
> I just used cifs to copy files to/from my nas and I noticed that its surprisingly slow. When copying from nas to a windows machine, I get a healthy 80-100mb/sec. When using my linux box with nfs, I also get 80-100mb/sec. But when I use cifs (mount command: mount -t cifs -o username=benjamin //10.0.0.6/video /mnt/nas_video/), the speed is a mere 20-25mb/sec. Am I doing something wrong or did I just find a speed regression?
>
> For a reference, I attached my kernel config
>
> Thank you
> Benjamin Schindler




--
Thanks,

Steve
