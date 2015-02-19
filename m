From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Question regarding kernel cifs mount bug with prefixpath
Date: Wed, 18 Feb 2015 21:53:27 -0600
Message-ID: <CADT32eJ0-uCuejbsNd9g6TObrPWo5yUEVO+wnPig_3r_70pKsg@mail.gmail.com>
References: <CAA8UQJs35wma7DyY1PoBEadnveA5oU+3vF+8EH6KAJaZgJAcgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: David Gelvin <david.gelvin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA8UQJs35wma7DyY1PoBEadnveA5oU+3vF+8EH6KAJaZgJAcgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

 I had posted a patchset as a solution to this problem on this mailing
list as well as in samba bugzilla 8950.  You may want to apply that
patchset and see if it fixes your problem.

On Wed, Feb 18, 2015 at 4:57 PM, David Gelvin <david.gelvin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I am trying to mount a specific NetApp CIFS share from various Linux
> distributions using the 3.x kernel.  I am able to mount the share root
> with no problem:
>
> mount -t cifs //host/share /mnt/cifs
>
> However, any attempt to mount a subdirectory fails:
>
> mount -t cifs //host/share/subdir/subsubdir /mnt/cifs
> mount error(2): No such file or directory
>
> I can easily navigate to and browse subdir/subsubdir when I mount the
> share root- I just can't mount the subdirectory as a prefixpath.
>
> Using a packet sniffer I see:
>
> QUERY_PATH_INFO, Query File All Info, Path: \\host\share\\subdir\subsubdir
> QUERY_PATH_INFO, Error: STATUS_UNSUCCESSFUL
>
> It looks like the kernel is adding an additional slash to the query,
> between the share name and the prefixpath.  While many CIFS servers
> seem to be fine with this, the NetApp device is not.
>
> This prefixpath mount works successfully with any 2.6 kernel with the
> same NetApp device.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
