From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Issue with upgrade to kernel 3.4.10 -> invalid argument error
Date: Tue, 16 Oct 2012 14:04:27 -0500
Message-ID: <CAH2r5muFU0wsC7BiDADdFN4udvJifQnjqTbKX8ozD1yy0eVjiQ@mail.gmail.com>
References: <507D934E.9010304@innominate.com>
	<CAH2r5mvFzSy5+SxpiBvuLydrsQcuJZn=5s6VCKgWO+K0iergMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvFzSy5+SxpiBvuLydrsQcuJZn=5s6VCKgWO+K0iergMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Why the ' (apostrophes) around the arguments to -o ?

What version of mount.cifs ("/sbin/mount.cifs -V" will display it) are you
using?


On Tue, Oct 16, 2012 at 12:03 PM, Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
wrote:
>
> Greetings,
>
>
> I am having an issue mounting CIFS shares since we upgraded our Linux
> kernel from 2.6.27 to 3.4.10. Each time I try to mount a share drive I get
> an "Invalid argument" error message even though I am using the same command
> line that had previously worked, e.g.:
>
> mount -t cifs //172.16.1.10/allusers /mnt/TEST -o
> 'ro,user=cifs,password=secret
>
> I went ahead and checked the source code, and found out that the following
> condition did not evaluate to true:
>
> fs/cifs/connect.c:2130
>         if (volume_info->UNCip && volume_info->UNC)
>         {
>                 rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
>                             volume_info->UNCip,
>                             strlen(volume_info->UNCip),
>                             volume_info->port);
>
> Thus I obtained a kernel message "Connecting to DFS root not implemented
> yet." So I am now explicitly specifying the UNC as an option, as well as the
> device name:
>
> mount -t cifs //172.16.1.10/allusers /mnt/TEST -o
> 'ro,user=cifs,password=secret,unc=\\172.16.1.10\allusers'
>
> Question #1: Why do I have to explicitly provide the UNC now?
>
> It almost seem like a bug to me, given that the devname parameter to the
> cifs_parse_mount_options function already contains this information. The
> newest sources for the 3.7-rc1 kernel seem to have no changes in this regard
> (even though I just took a *quick* look at those sources.)
>
> If this is a bug I would be glad to provide a patch to fix it.
>
> The second observation that I made concerned specifying the UNC as an
> option and passing in slashes as separators instead of backslashes:
>
> mount -t cifs //172.16.1.10/allusers /mnt/TEST -o
> 'ro,user=cifs,password=secret,unc=//172.16.1.10/allusers'
>
> This also results in an invalid argument error, as the parser does not
> convert all slashes into backslashes (for the unc option, as the devname
> parameter is already converted!), and thus extract_hostname is not able to
> function properly.
>
> Question #2: Should this be considered a bug?
>
> If that is the case, I would like to suggest the attached bugfix.
>
> Please let me know what you think and thank you in advance for your kind
> support!
>
>
> Best regards,
>
>
> --
> Federico Sauter / Senior firmware programmer
> Innominate Security Technologies AG / protecting industrial networks
> tel: +49.30.921028-210 / fax: +49.30.921028-020
> Rudower Chaussee 13 / D-12489 Berlin / http://www.innominate.com/
>
> Register Court: AG Charlottenburg, HR B 81603
> Management Board: Dirk Seewald
> Chairman of the Supervisory Board: Christoph Leifer




--
Thanks,

Steve



--
Thanks,

Steve
