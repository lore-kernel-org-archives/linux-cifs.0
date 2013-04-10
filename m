From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while smbclient
 works
Date: Wed, 10 Apr 2013 09:04:15 -0400
Message-ID: <20130410090415.7e1c40b3@corrin.poochiereds.net>
References: <20130408194049.GE10949@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130408194049.GE10949-MEsB+WDYHc7QKvwJT6wXshvVK+yQ3ZXh@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 8 Apr 2013 21:40:49 +0200
Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org> wrote:

> Hi,
> 
> I own a Canon MX 420 scanner which can scan to a memory card and then
> offer the scanned information via CIFS. Up to a few kernel versions
> ago (I think it worked with 3.6, but am not sure about that), things
> worked just fine and then stopped.
> 
> The issue is the following:
> 
> $ sudo mount.cifs  '\\mx420-sch8.local\canon_memory' /media/scanner -o user=anonymous,nounix --verbose
> Password: <enter>
> mount.cifs kernel mount options: ip=192.168.218.36,unc=\\mx420-sch8.local\canon_memory,nounix,user=anonymous,pass=********
> mount error(5): Input/output error
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> A pcap file of the network traffic caused by this command can be
> downloaded from http://q.bofh.de/~mh/stuff/tcpdump.mount.cifs.
> 
> Otoh, smbclient '\\mx420-sch8.local\canon_memory' works. A pcap file
> of the network traffic caused by this command can be downloaded from
> http://q.bofh.de/~mh/stuff/tcpdump.smbclient.
> 
> As somebody not knowing CIFS too well, I note that smbclients tries as
> anonymous, while the kernel tries to log in first and receives an
> error answer from the scanner.
> 
> This behavior has changed at some point of the last six months. The
> kernel 3.7 found in grml's 2013.02 release works, at least the 3.8.5
> currently running on my notebook doesn't.
> 
> Any hints how do address this issue?
> 
> Greetings
> Marc
> 

(cc'ing Steve)

Looks like more fallout from commit 81bcd8b795229c. Steve, weren't you
working on a patch to fix the client to handle the situation where the
server replies to the NEGOTIATE with the extended security bit clear?

In any case, a workaround for now might be to try and mount with
sec=none. I *think* that will make the client do what smbclient is
doing here.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
