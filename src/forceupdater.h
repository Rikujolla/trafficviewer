#ifndef FORCEUPDATER_H
#define FORCEUPDATER_H
// With the help of John Temples qml@xargs.com
//#include <QObject>
#include <QProcess>
#include <QVariant>

class Forceupdate : public QProcess
{
    Q_OBJECT

public:
    Forceupdate(QObject *parent = 0) : QProcess(parent){}
    Q_INVOKABLE void start(const QString &program, const QVariantList &arguments) {
    //Q_INVOKABLE void start(const QString &program) {
        QStringList args;
        for (int i=0; i < arguments.length(); i++)
            args << arguments[i].toString();
        QProcess::start(program,args);
        //QProcess::start("timedclient-qt5 -a'whenDue;runCommand=/home/nemo/.scripts/test.sh@nemo' -e'APPLICATION=Autoambience2;TITLE=Autoambience2_test;ticker=60'");
        //QProcess::start(program);
    }

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }


};

#endif // FORCEUPDATER_H
