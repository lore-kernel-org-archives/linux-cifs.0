From: "Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Subject: Re: Ubuntu SecurityFlags at boot
Date: Tue, 02 Oct 2012 01:24:57 -0400
Message-ID: <506A7AA9.2090606@appcomsci.com>
References: <506A17EB.2050908@appcomsci.com> <20121001214848.45781bb3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001214848.45781bb3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you so much for explaining what should have been utterly obvious. 
  It worked perfectly when I did this:

% sudo -i
# echo 0x30030 > /proc/fs/cifs/SecurityFlags
# mount -t cifs //myoldtiredserver/lott /mnt

I'm still getting used to using echo for communicating with a kernel 
module but that's just gonna take time :)

On 10/01/2012 09:48 PM, Jeff Layton wrote:
> The sudo in the above command just covers the echo command. The shell
> redirection (and hence the write to SecurityFlags) is done as the
> original user, which is why you're getting EACCES. You probably want
> to do something like this to ensure that the shell redirection is done
> as root as well:
>
>      $ sudo sh -c "echo 0x30030 > /proc/fs/cifs/SecurityFlags"
>
