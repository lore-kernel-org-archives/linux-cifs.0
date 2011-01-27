From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [linux-cifs-client] can someone please explain the performance
 difference between mount.cifs and smbclient?
Date: Thu, 27 Jan 2011 13:54:10 -0500
Message-ID: <20110127135410.6046a8cd@barsoom.rdu.redhat.com>
References: <20110127190719.72653d38@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110127190719.72653d38-rv+Yua7s+pdxcfAO2cft21aTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Jan 2011 19:07:19 +0100
Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org> wrote:

> 
> Using mount -t cifs //server/share /mnt/share between two big servers
> connected with 10GigE, I've got : 115 MB/s reading, 132 MB/s writing. 
> Using smbclient, I've got 450 MB/s reading, 132 MB/s writing (NFS gives
> ~ 260 MB/s write, 550 MB/s read on the same setup, with absolutely zero
> optimisation).
> 
> Why this huge difference? BTW, why such a discrepancy between read and
> write speed? 

FWIW, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org is deprecated.

cc'ing linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org which is the new mailing list...

Most likely you're seeing the result of a lack of parallelism in the
Linux kernel cifs client. It does not do async writes (yet), which
really hinders throughput.

I'm hoping to get to work on that in the next few months unless someone
else beats me to it...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
