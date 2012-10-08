From: Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Subject: DFS and ls: cannot access /some/path: Object is remote
Date: Mon, 08 Oct 2012 16:18:34 +0400
Message-ID: <5072C49A.6010108@telros.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!
I have a problem using DFS share with a number of user applications
(like libreoffice, thunderbird, etc.). The problem is that I can't enter
to any part of a dfs share (link to another share) via file manager,
because fm can't list contents of directory with dfs links properly. In
terminal it looks like this:

/tmp/test - mounted dfs share
/tmp/test/all - real directory on the server with dfs share
/tmp/test/all/* - dfs links

# ls /tmp/test/all/*
ls: cannot access /tmp/test/all/admin: Object is remote
ls: cannot access /tmp/test/all/drivers: Object is remote
ls: cannot access /tmp/test/all/linux-iso: Object is remote

Same time, listing of the one link works fine:
# ls /tmp/test/all/linux-iso
file1
file2
file3

After listing "linux-iso":
1) with kernel 3.2 listing of * looks the same;
2) with kernel 3.6.1 listing of * looks differ:
# ls /tmp/test/all/*
ls: cannot access /tmp/test/all/admin: Object is remote
ls: cannot access /tmp/test/all/drivers: Object is remote

/tmp/test/all/linux-iso:
file1
file2
file3

and user apps now see "linux-iso" as directory. It's better then 3.2 ...
... but after some amount of time "linux-iso" link becomes unavailable
(Object is remote) again.

So, the question: is there a way to make kernel list contents of all dfs
links in the directory/share. I see two ways to do so:
1) show dfs links as directories, not links (without actual connection
to it, if it's possible)
2) try to connect and mount every link when app try to list the
directory with links (it will be slow, but it will work at least)

Thanks.

-- 
Best regards,
Sergey Urushkin
