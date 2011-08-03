From: Steffie Morris <steffie.morris-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: optimize mount.cifs for speed?
Date: Wed, 3 Aug 2011 13:52:21 +0200
Message-ID: <CALEFH9SHkdgtLeruSLbEB9HjXAa=SscbFF4C2+yj1sB6i+vMcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi, i have some questions (and problems) regarding speed in linux
using mount -t cifs for cifs shares.

I have several ubuntu 10.10 workstations and a few windows
workstations, on wich i want to interact from one central fileshare.
At the moment i have a fileshare on a windows7 machine, and a
fileshare (samba) on an ubuntu machine.
The netwerk is 1 Gbit
>From a windows client uploading/downloading to the linux samba server
i get 115 MB/s.
>From a window client uploading/downloading to  a windows share i get
around 110 MB/s.
>From the linux client uploading to the windows share i get 60 MB/s.
>From the linux client reading from the windows share i get 17 MB/s.
>From the linux client uploading to the linux samba  server i get 60 MB/s.
>From t he linux client reading from the linux samba share i get 17MB/s.

The biggest problem question i face, is why is reading thru a "mount
-t cifs" share this slow?
If the linux machine acts as a server the speed is really fast (in
combination with a windows client) but when i use the linux machine as
a client, the performance is not good.
Am i overlooking something? should i be using special options to
optimize performance for cifs in client mode on linux ?
I think i ruled out hardware network issue's as traffic the other way
around works (with linux as serving share), and also via FTP, or
testing with iperf gives me near full Gbit speeds.

I tried to do some searches on speed and perfomance issues, but didn't
find anything usefull so far.

Best regards,
Steffie
